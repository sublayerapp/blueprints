describe Api::V1::BlueprintVariantsController, type: :controller do
  let!(:blueprint) do
    create(:blueprint,
      name: 'ChessRookPieceClass',
      description: "The code defines a Rook class, which inherits from the Piece class. It represents a rook piece in a chess game. It includes methods to represent the rook symbol using Unicode character '\\u265C' and to generate all possible rook moves on a chessboard based on straight line movements. The class includes a private straight_moves method that calculates all valid moves considering the chessboard layout and the presence of other pieces. This method checks for moves in four cardinal directions, adds empty squares to the valid moves, and captures if the square is occupied by an opposing piece, halting further movement in that direction if any square is either invalid or occupied by a same-color piece.",
      code: "class Rook < Piece\n  def symbol\n    \"\\u265C\"\n  end\n\n  def moves\n    straight_moves\n  end\n\n  private\n\n  def straight_moves\n    moves = []\n    directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]\n\n    directions.each do |dx, dy|\n      current_x, current_y = pos\n\n      while true\n        current_x += dx\n        current_y += dy\n        current_pos = [current_x, current_y]\n\n        break unless board.valid_pos?(current_pos)\n\n        if board.empty?(current_pos)\n          moves << current_pos\n        else\n          moves << current_pos if board[current_pos].color != color\n          break\n        end\n      end\n    end\n\n    moves\n  end\nend"
    )
  end
  let(:description) { 'ruby knight class for chess' }

  let(:attempts) { 1 }

  it 'attempts to get variant' do
    folder_name = Time.now.strftime("%Y%m%d%H%M%S")
    Dir.mkdir("spec_performance/llms/results/#{folder_name}")
    YAML.load_file('spec_performance/llms/ai_models.yml').each do |provider, models|
      is_local = provider == 'Local'
      Sublayer.configuration.ai_provider = "Sublayer::Providers::#{provider}".constantize
      models.each do |model,arg|
        Sublayer.configuration.ai_model = (is_local) ? 'LLaMA_CPP' : model
        pid = start_and_wait_for_local_model(arg['location'], model) if is_local

        puts "#{provider} - #{model}"
        results = run_performance_test(folder_name, attempts, is_local)
        clean_up_local_model(pid) if is_local

        File.rename("spec_performance/llms/results/#{folder_name}/results.csv", "spec_performance/llms/results/#{folder_name}/#{provider}_#{model.delete_suffix('.gguf')}_#{results}.csv")
      end
    end
  end

  def run_performance_test(folder_name, attempts, is_local)
    times = []
    codes = []
    CSV.open("spec_performance/llms/results/#{folder_name}/results.csv", 'w') do |csv|
      attempts.times do
        time0 = Time.now.to_i
        begin
          post :create, params: { description: description }
          elapsed_time = Time.now.to_i - time0

          generated_code = JSON.parse(response.body)['result']
          csv << [response.code, elapsed_time, generated_code, response.body]

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
end