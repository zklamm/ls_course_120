class Board
  INITIAL_MARKER = '  '
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # cols
    [1, 5, 9], [3, 5, 7]             # diag
  ]

  attr_accessor :squares

  def initialize
    reset
  end

  def reset
    @squares = {}
    (1..9).each { |i| squares[i] = INITIAL_MARKER }
  end

  # rubocop:disable Metrics/AbcSize
  def display_squares
    puts "      |      |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "      |      |"
    puts "------+------+-----"
    puts "      |      |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "      |      |"
    puts "------+------+-----"
    puts "      |      |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "      |      |"
  end
  # rubocop:enable Metrics/AbcSize

  def empty_squares
    squares.select { |_, square| square == INITIAL_MARKER }.keys
  end

  def full?
    empty_squares.empty?
  end

  def determine_winner
    WINNING_LINES.each do |line|
      human_sum = 0
      computer_sum = 0
      line.each do |square|
        human_sum += 1 if squares[square] == TTT::HUMAN_MARKER
        computer_sum += 1 if squares[square] == TTT::COMPUTER_MARKER
        return :human if human_sum == 3
        return :computer if computer_sum == 3
      end
    end
    false
  end

  def winner?
    determine_winner
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def incremement_score
    self.score += 1
  end
end

class TTT
  HUMAN_MARKER = '❌'
  COMPUTER_MARKER = '⭕'
  WINNING_SCORE = 3

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def clear_screen
    (system 'cls') || (system 'clear')
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to Tic Tac Toe!"
    puts ""
    puts "The first to win #{WINNING_SCORE} rounds is the champion!"
    puts ""
    puts "Hit 'enter' to begin!"
    gets
  end

  def display_board
    clear_screen
    puts "You are #{HUMAN_MARKER}. Computer is #{COMPUTER_MARKER}."
    puts ""
    board.display_squares
    puts ""
  end

  def joinor(ary, delim=', ', word=' or ')
    case ary.size
    when 0 then ''
    when 1 then ary.first
    when 2 then "#{ary[0]}#{word}#{ary[-1]}"
    else "#{ary[0..-2].join(delim)},#{word}#{ary[-1]}"
    end
  end

  def human_move
    choice = ''
    loop do
      puts ""
      puts "Choose a square: (#{joinor(board.empty_squares)})"
      choice = gets.to_i
      break if board.empty_squares.include?(choice)
      puts "Invalid choice."
    end
    board.squares[choice] = HUMAN_MARKER
  end

  def computer_move
    board.squares[board.empty_squares.sample] = COMPUTER_MARKER
  end

  def play_again?
    puts "Play again? Enter 'y' or 'n'"
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Invalid choice. Enter 'y' or 'n'"
    end
    answer == 'y'
  end

  def display_winner
    display_board
    case board.determine_winner
    when :human    then puts "You won!"
    when :computer then puts "Computer won!"
    else                puts "It's a tie!"
    end
  end

  def update_score
    case board.determine_winner
    when :human    then human.incremement_score
    when :computer then computer.incremement_score
    end
  end

  def display_score
    puts ""
    puts "Your score: #{human.score}"
    puts "Computer score: #{computer.score}"
    puts ""
  end

  def score_not_met?
    human.score < WINNING_SCORE && computer.score < WINNING_SCORE
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing! Goodbye!"
    puts ""
  end

  def inner_game_loop
    loop do
      display_board
      human_move
      break if board.full? || board.winner?
      computer_move
      break if board.full? || board.winner?
    end
  end

  def outer_game_loop
    loop do
      board.reset
      inner_game_loop
      display_winner
      update_score
      display_score
      break unless score_not_met? && play_again?
    end
  end

  def play
    display_welcome_message
    outer_game_loop
    display_goodbye_message
  end
end

TTT.new.play
