class Square
  INITIAL_MARKER = '  '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def empty?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  private

  def to_s
    marker
  end
end

class Board
  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # cols
    [1, 5, 9], [3, 5, 7]             # diag
  ]

  attr_accessor :squares, :final_square, :guides

  def initialize
    reset
  end

  def reset
    @guides = (1..9).to_a
    @squares = {}
    (1..9).each { |i| squares[i] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def display_squares
    puts "#{guides[0]}     |#{guides[1]}     |#{guides[2]}"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "      |      |"
    puts "------+------+-----"
    puts "#{guides[3]}     |#{guides[4]}     |#{guides[5]}"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "      |      |"
    puts "------+------+-----"
    puts "#{guides[6]}     |#{guides[7]}     |#{guides[8]}"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "      |      |"
  end
  # rubocop:enable Metrics/AbcSize

  def empty_squares
    squares.keys.select { |key| squares[key].empty? }
  end

  def remove_guide
    squares.each_key { |key| guides[key - 1] = ' ' if squares[key].marked? }
  end

  # if, out of the remaining squares, the opponent has their marker present at
  # least once in each of the winning lines, then there are no possible wins.

  def no_possible_wins?(opponent_marker)
    WINNING_LINES.all? do |line|
      markers = squares.values_at(*line).map(&:marker)
      markers.count(opponent_marker) >= 1
    end
  end

  # def no_possible_wins?
  #   empty_squares.count == 1
  # end

  def winner?
    !!determine_winner
  end

  def one_square_left?(potential_winning_marker)
    WINNING_LINES.each do |line|
      markers = squares.values_at(*line).map(&:marker)
      if markers.count(potential_winning_marker) == 2 &&
         markers.count(Square::INITIAL_MARKER) == 1
        empty_key = determine_final_square(line)
        if squares[empty_key].empty?
          self.final_square = empty_key
          return true
        end
      end
    end
    false
  end

  def determine_final_square(line)
    line.sort_by { |key| squares[key].marker }.first
  end

  def square_five_empty?
    squares[5].empty?
  end

  def take_square_five
    squares[5].marker = TTT::COMPUTER_MARKER
  end

  def random_choice
    squares[empty_squares.sample].marker = TTT::COMPUTER_MARKER
  end

  def take_final_square
    squares[final_square].marker = TTT::COMPUTER_MARKER
  end

  def determine_winner
    WINNING_LINES.each do |line|
      winners = squares.values_at(*line)
      return winners.first.marker if three_identical_markers?(winners)
    end
    nil
  end

  private

  def three_identical_markers?(markers)
    return false unless markers.map(&:marker).uniq.size == 1
    return false if markers.any?(&:empty?)
    markers.map(&:marker).uniq.size == 1
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

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @first_player = 'computer' # can be 'human', 'computer', or choose
  end

  def play
    display_welcome_message
    choose_first_player if choose?
    display_first_player
    outer_game_loop
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer

  def display_welcome_message
    clear_screen
    puts "Welcome to Tic Tac Toe!"
    puts ""
    puts "The first to win #{WINNING_SCORE} rounds is the champion!"
    puts ""
    puts "Hit 'enter' to continue!"
    gets
  end

  def clear_screen
    (system 'cls') || (system 'clear')
  end

  def choose?
    @first_player == 'choose'
  end

  def choose_first_player
    clear_screen
    puts "Would you like to go first? Enter 'y' or 'n'"
    @first_player = determine_yes_or_no == 'y' ? 'human' : 'computer'
  end

  def determine_yes_or_no
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Invalid choice. Enter 'y' or 'n'"
    end
    answer
  end

  def display_first_player
    puts ""
    case @first_player
    when 'human'    then puts "OK, you move first!"
    when 'computer' then puts "OK, computer moves first!"
    end
    puts ""
    puts "Hit 'enter' to begin!"
    gets
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

  def inner_game_loop
    loop do
      current_player_move
      board.remove_guide
      alternate_current_player
      break if board.no_possible_wins?(opponent_marker) || board.winner?
    end
  end

  def opponent_marker
    @current_player == 'human' ? COMPUTER_MARKER : HUMAN_MARKER
  end

  def current_player_move
    display_board
    case @first_player
    when 'human'    then human_move
    when 'computer' then computer_move
    end
  end

  def display_board
    clear_screen
    puts "You are #{HUMAN_MARKER}. Computer is #{COMPUTER_MARKER}."
    puts ""
    board.display_squares
    puts ""
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
    board.squares[choice].marker = HUMAN_MARKER
  end

  def joinor(ary, delim=', ', word=' or ')
    case ary.size
    when 0 then ''
    when 1 then ary.first
    when 2 then "#{ary[0]}#{word}#{ary[-1]}"
    else "#{ary[0..-2].join(delim)},#{word}#{ary[-1]}"
    end
  end

  def computer_move
    if board.one_square_left?(COMPUTER_MARKER) ||
       board.one_square_left?(HUMAN_MARKER)
      board.take_final_square
    elsif board.square_five_empty?
      board.take_square_five
    else
      board.random_choice
    end
  end

  def alternate_current_player
    if human?
      @first_player = 'computer'
    elsif computer?
      @first_player = 'human'
    end
  end

  def human?
    @first_player == 'human'
  end

  def computer?
    @first_player == 'computer'
  end

  def display_winner
    display_board
    case board.determine_winner
    when HUMAN_MARKER    then puts "You won!"
    when COMPUTER_MARKER then puts "Computer won!"
    else                 puts "It's a tie!"
    end
  end

  def update_score
    case board.determine_winner
    when HUMAN_MARKER    then human.incremement_score
    when COMPUTER_MARKER then computer.incremement_score
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

  def play_again?
    puts "Play again? Enter 'y' or 'n'"
    determine_yes_or_no == 'y'
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing! Goodbye!"
    puts ""
  end
end

TTT.new.play
