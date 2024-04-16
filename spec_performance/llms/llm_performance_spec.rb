describe Api::V1::BlueprintVariantsController, type: :controller do
  let(:description) { 'A Knight class for chess' }
  let(:attempts) { 3 }

  context 'well named' do
    let(:symbol_method) {'symbol'}
    let(:moves_method) {'moves'}

    let!(:blueprint) do
      create(:blueprint,
        name: 'ChessRookClass',
        description: "A Ruby Rook class for chess",
        code: "
          class Rook < Piece
            def #{symbol_method}
              \"\u265C\"
            end
            def #{moves_method}
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
          end"
      )
    end
    it 'attempts to get variant' do
      folder_name = Time.now.strftime("%Y%m%d%H%M%S") + 'well-named'
      Dir.mkdir("spec_performance/llms/results/#{folder_name}")
      YAML.load_file('spec_performance/llms/ai_models.yml').each do |provider, models|
        is_local = provider == 'Local'
        Sublayer.configuration.ai_provider = "Sublayer::Providers::#{provider}".constantize
        models.each do |model,arg|
          Sublayer.configuration.ai_model = (is_local) ? 'LLaMA_CPP' : model
          pid = start_and_wait_for_local_model(arg['location'], model) if is_local

          puts "#{provider} - #{model}"
          results = run_performance_test(folder_name, attempts, is_local || model == 'gemini-1.5-pro-latest')
          clean_up_local_model(pid) if is_local

          File.rename("spec_performance/llms/results/#{folder_name}/results.csv", "spec_performance/llms/results/#{folder_name}/#{provider}_#{model.delete_suffix('.gguf')}_#{results}.csv")
        end
      end
    end
  end

  context 'innaccurate names' do
    let(:symbol_method) {'age'}
    let(:moves_method) {'height'}

    let!(:blueprint) do
      create(:blueprint,
        name: 'ChessRookClass',
        description: "A Ruby Rook class for chess",
        code: "
          class Rook < Piece
            def #{symbol_method}
              \"\u265C\"
            end
            def #{moves_method}
              s_m
            end
            private
            def s_m
              ms = []
              ds = [[0, 1], [0, -1], [1, 0], [-1, 0]]
              ds.each do |some, thing|
                x, y = pos
                while true
                  x += some
                  y += thing
                  break unless board.valid_pos?(pos)
                  if board.empty?(pos)
                    ms << pos
                  else
                    ms << pos if board[pos].color != color
                    break
                  end
                end
              end
              ms
            end
          end"
      )
    end
    it 'attempts to get variant w unhelpful names' do
      folder_name = Time.now.strftime("%Y%m%d%H%M%S") + 'unhelpful'
      Dir.mkdir("spec_performance/llms/results/#{folder_name}")
      YAML.load_file('spec_performance/llms/ai_models.yml').each do |provider, models|
        is_local = provider == 'Local'
        Sublayer.configuration.ai_provider = "Sublayer::Providers::#{provider}".constantize
        models.each do |model,arg|
          Sublayer.configuration.ai_model = (is_local) ? 'LLaMA_CPP' : model
          pid = start_and_wait_for_local_model(arg['location'], model) if is_local

          puts "#{provider} - #{model}"
          results = run_performance_test(folder_name, attempts, is_local || model == 'gemini-1.5-pro-latest')
          clean_up_local_model(pid) if is_local

          File.rename("spec_performance/llms/results/#{folder_name}/results.csv", "spec_performance/llms/results/#{folder_name}/#{provider}_#{model.delete_suffix('.gguf')}_#{results}.csv")
        end
      end
    end
  end

  context 'malicious names ' do
    let(:symbol_method) {'directions'}
    let(:moves_method) {'to_s'}
    let!(:blueprint) do
      create(:blueprint,
        name: 'ChessRookClass',
        description: "A Ruby Rook class for chess",
        code: "
          class Rook < Piece
            def #{symbol_method}
              \"\u265C\"
            end
            def #{moves_method}
              to_i
            end
            private
            def to_i
              more_binaries = []
              zeroes_and_ones = [[0, 1], [0, -1], [1, 0], [-1, 0]]
              zeroes_and_ones.each do |dx, dy|
                x, y = pos
                while true
                  x += dx
                  y += dy
                  break unless board.valid_pos?(pos)
                  if board.empty?(pos)
                    more_binaries << pos
                  else
                    more_binaries << pos if board[pos].color != color
                    break
                  end
                end
              end
              more_binaries
            end
          end"
      )
    end

    it 'attempts to get variant w malicious names' do
      folder_name = Time.now.strftime("%Y%m%d%H%M%S") + 'malicious'
      Dir.mkdir("spec_performance/llms/results/#{folder_name}")
      YAML.load_file('spec_performance/llms/ai_models.yml').each do |provider, models|
        is_local = provider == 'Local'
        Sublayer.configuration.ai_provider = "Sublayer::Providers::#{provider}".constantize
        models.each do |model,arg|
          Sublayer.configuration.ai_model = (is_local) ? 'LLaMA_CPP' : model
          pid = start_and_wait_for_local_model(arg['location'], model) if is_local

          puts "#{provider} - #{model}"
          results = run_performance_test(folder_name, attempts, is_local || model == 'gemini-1.5-pro-latest')
          clean_up_local_model(pid) if is_local

          File.rename("spec_performance/llms/results/#{folder_name}/results.csv", "spec_performance/llms/results/#{folder_name}/#{provider}_#{model.delete_suffix('.gguf')}_#{results}.csv")
        end
      end
    end
  end

  def run_performance_test(folder_name, attempts, is_local)
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
          quality_checks << generated_code_works?(generated_code)
          csv << [response.code, elapsed_time, quality_checks.last, generated_code, response.body]

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

  def generated_code_works?(generated_code)
    restricted_context = binding # protect from eval attempts to access the outside world
    piece_class = "class Piece\n  attr_reader :color, :board\n  attr_accessor :pos\n  def initialize(color, board, pos)\n    @color, @board, @pos = color, board, pos\n    board[pos] = self\n  end\nend\n"
    board_class = "class Board\n  def initialize(fill_board = true)\n    @rows = Array.new(8) { Array.new(8) }\n  end\n  def [](pos)\n    row, col = pos\n    @rows[row][col]\n  end\n  def []=(pos, piece)\n    row, col = pos\n    @rows[row][col] = piece\n  end\n  def valid_pos?(pos)\n    pos.all? { |coord| coord.between?(0, 7) }\n  end\n  def empty?(pos)\n    self[pos].nil?\n  end\nend\n"

    works = 0
    begin
      eval(piece_class, restricted_context)
      eval(board_class, restricted_context)
      eval(generated_code, restricted_context)
      board_class = restricted_context.eval('Board')
      knight_class = restricted_context.eval('Knight')
      board = board_class.new

      return true if run_test(knight_class, board)
    rescue StandardError, SyntaxError => e
      p e
      return false
    end
  end

  def run_test(knight_class, board)
    knight = knight_class.new(:white, board, [4,4])
    correct_knight_moves = [[2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]]

    ["♞","♘"].include?(knight.send(symbol_method)) && knight.send(moves_method).sort == correct_knight_moves
  end
end