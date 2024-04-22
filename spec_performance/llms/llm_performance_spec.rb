describe Api::V1::BlueprintVariantsController, type: :controller do
  let(:method_names) do
    {
      well_named: [:symbol, :moves],
      poorly_named: [:s, :m_s],
      maliciously_named: [:directions, :to_s]
    }
  end
  let(:well_named_code) do
    <<-CODE
class Rook < Piece
  def #{method_names[:well_named][0]}
    "\u265C"
  }
  end
  def #{method_names[:well_named][1]}
    straight_moves
  end
  private
  def straight_moves
    moves = []
    directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    directions.each do |dx, dy|
      x, y = pos
      while true
        x += dx
        y += dy
        break unless board.valid_pos?(pos)
        if board.empty?(pos)
          moves << pos
        else
          moves << pos if board[pos].color != color
          break
        end
      end
    end
    moves
  end
end
CODE
  end
  let(:poorly_named_code) do
    <<-CODE
class Rook < Piece
  def #{method_names[:poorly_named][0]}
    "\u265C"
  end
  def #{method_names[:poorly_named][1]}
    s_m
  end
  private
  def s_m
    m = []
    ms = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    ms.each do |dx, dy|
      x, y = pos
      while true
        x += dx
        y += dy
        break unless board.valid_pos?(pos)
        if board.empty?(pos)
          m << pos
        else
          m << pos if board[pos].color != color
          break
        end
      end
    end
    m
  end
end
CODE
  end
  let(:maliciously_named_code) do
    <<-CODE
class Rook < Piece
  def #{method_names[:maliciously_named][0]}
    "\u265C"
  end
  def #{method_names[:maliciously_named][1]}
    straight_moves
  end
  private
  def straight_moves
    moves = []
    directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    directions.each do |dx, dy|
      x, y = pos
      while true
        x += dx
        y += dy
        break unless board.valid_pos?(pos)
        if board.empty?(pos)
          moves << pos
        else
          moves << pos if board[pos].color != color
          break
        end
      end
    end
    moves
  end
end
CODE
  end

  let(:description) { 'A Knight class for chess' }
  let(:attempts) { 1 }

  [:well_named, :poorly_named, :maliciously_named].each do |type|
    it 'attempts to get variant' do
      create(:blueprint,
        name: 'ChessRookClass',
        description: 'A Ruby Rook class for chess',
        code: send("#{type}_code")
      )

      folder_name = Time.now.strftime("%Y%m%d%H%M%S_#{type}")
      Dir.mkdir("spec_performance/llms/results/#{folder_name}")
      YAML.load_file('spec_performance/llms/ai_models.yml').each do |provider, models|
        is_local = provider == 'Local'
        Sublayer.configuration.ai_provider = "Sublayer::Providers::#{provider}".constantize
        models.each do |model,arg|
          Sublayer.configuration.ai_model = (is_local) ? 'LLaMA_CPP' : model
          pid = start_and_wait_for_local_model(arg['location'], model) if is_local

          puts "#{provider} - #{model}"
          results = run_performance_test(folder_name, attempts, is_local, type)
          clean_up_local_model(pid) if is_local

          File.rename("spec_performance/llms/results/#{folder_name}/results.csv", "spec_performance/llms/results/#{folder_name}/#{provider}_#{model.delete_suffix('.gguf')}_#{results}.csv")
        end
      end
    end
  end

  def run_performance_test(folder_name, attempts, is_local, type)
    times = []
    codes = []
    quality_checks = []
    CSV.open("spec_performance/llms/results/#{folder_name}/results.csv", 'w') do |csv|
      attempts.times do
        time0 = Time.now.to_i
        begin
          post :create, params: { description: description }
          elapsed_time = Time.now.to_i - time0

          generated_code = JSON.parse(response.body)['result']
          works = generated_code_works?(generated_code, type)
          quality_checks << works
          csv << [response.code, elapsed_time, works, generated_code, response.body]

          times << elapsed_time
          codes << response.code
        rescue StandardError => e
          elapsed_time = Time.now.to_i - time0
          csv << [e, elapsed_time]

          times << elapsed_time
          codes << '500'
        end

        sleep 2 if is_local
      end

      average_time = times.sum / times.size
      puts "times: #{times.map {|t| "#{t}s"}.join(', ')}"
      puts "Average time: #{average_time}"
      puts "Success: #{codes.count("200")} / #{codes.size}"
      puts "Quality Checks: #{quality_checks.count(true)} / #{quality_checks.size}"

      "#{average_time}seconds_#{codes.count('200')}successes"
    end
  end

  def start_and_wait_for_local_model(location, model)
    pid = Process.spawn("llamafile -ngl 9999 --host 0.0.0.0 --nobrowser -c 2048 --gpu APPLE -t 12 --log-disable -m #{location}/#{model}.gguf", out: File::NULL, err: File::NULL)
    max = 60 # 2 minutes
    i = 0
    until system('nc -z localhost 8080 > /dev/null 2>&1') do
      Process.kill('TERM', pid) and break if i > 30
      sleep(2) and i += 1
    end
    pid
  end

  def clean_up_local_model(pid)
    Process.kill('TERM', pid)
    sleep(2) while system('nc -z localhost 8080 > /dev/null 2>&1')
  end

  def generated_code_works?(generated_code, type)
    restricted_context = binding # protect from eval attempts to access the outside world
    piece_class = "class Piece\n  attr_reader :color, :board\n  attr_accessor :pos\n  def initialize(color, board, pos)\n    @color, @board, @pos = color, board, pos\n    board[pos] = self\n  end\n  def inspect\n    { color: color, pos: pos, symbol: symbol }.inspect\n  end\n  def to_s\n    \" \#{symbol.colorize(color: colorize_color)} \"\n  end\n  def empty?\n    false\n  end\n  def valid_moves\n    moves.reject { |end_pos| move_into_check?(end_pos) }\n  end\n  def move_into_check?(end_pos)\n    test_board = board.dup\n    test_board.move_piece!(pos, end_pos)\n    test_board.in_check?(color)\n  end\n  def colorize_color\n    color == :white ? :light_white : :black\n  end\nend\n"
    board_class = "class Board\n  def initialize(fill_board = true)\n    @rows = Array.new(8) { Array.new(8) }\n  end\n  def [](pos)\n    row, col = pos\n    @rows[row][col]\n  end\n  def []=(pos, piece)\n    row, col = pos\n    @rows[row][col] = piece\n  end\n  def checkmate?(color)\n    return false unless in_check?(color)\n    pieces.select { |piece| piece.color == color }.all? do |piece|\n      piece.valid_moves.empty?\n    end\n  end\n  def move_piece(turn_color, start_pos, end_pos)\n    raise \"No piece at start position\" if self[start_pos].nil?\n    raise \"Piece cannot move like that\" unless self[start_pos].moves.include?(end_pos)\n    raise \"You cannot move into check\" unless self[start_pos].valid_moves.include?(end_pos)\n    move_piece!(start_pos, end_pos)\n  end\n  def move_piece!(start_pos, end_pos)\n    piece = self[start_pos]\n    raise \"Piece cannot move like that\" unless piece.moves.include?(end_pos)\n    self[end_pos] = piece\n    self[start_pos] = nil\n    piece.pos = end_pos\n  end\n  def in_check?(color)\n    king_pos = find_king(color).pos\n    pieces.any? { |piece| piece.color != color && piece.moves.include?(king_pos) }\n  end\n  def pieces\n    @rows.flatten.compact\n  end\n  def dup\n    new_board = Board.new(false)\n    pieces.each do |piece|\n      piece.class.new(piece.color, new_board, piece.pos)\n    end\n    new_board\n  end\n  def find_king(color)\n    pieces.find { |piece| piece.color == color && piece.is_a?(King) }\n  end\n  def valid_pos?(pos)\n    pos.all? { |coord| coord.between?(0, 7) }\n  end\n  def empty?(pos)\n    self[pos].nil?\n  end\nend"

    works = 0
    begin
      eval(piece_class, restricted_context)
      eval(board_class, restricted_context)
      eval(generated_code, restricted_context)
      board_class = restricted_context.eval('Board')
      knight_class = restricted_context.eval('Knight')
      board = board_class.new

      return true if run_test(knight_class, board, type)
    rescue StandardError, SyntaxError => e
      return false
    end
  end

  def run_test(knight_class, board, type)
    knight = knight_class.new(:white, board, [4,4])
    knight = knight_class.new(:white, board, [4,4])
    correct_knight_moves = [[2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]]

    ['♘','♞',"\u265E","\u2658"].include?(knight.send(method_names[type][0]).strip) && knight.send(method_names[type][1]).sort == correct_knight_moves
  end
end