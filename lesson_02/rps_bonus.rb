class Move
  VALUES = %w[rock paper scissors lizard spock]

  attr_accessor :value

  def initialize(value)
    @value = case value
             when 'rock'     then Rock.new(value)
             when 'paper'    then Paper.new(value)
             when 'scissors' then Scissors.new(value)
             when 'lizard'   then Lizard.new(value)
             when 'spock'    then Spock.new(value)
             end
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize(value)
    @value = value
  end

  def win?(other_move)
    value && (other_move.value == 'scissors' || other_move.value == 'lizard')
  end
end

class Paper < Move
  def initialize(value)
    @value = value
  end

  def win?(other_move)
    value && (other_move.value == 'spock' || other_move.value == 'rock')
  end
end

class Scissors < Move
  def initialize(value)
    @value = value
  end

  def win?(other_move)
    value && (other_move.value == 'lizard' || other_move.value == 'paper')
  end
end

class Lizard < Move
  def initialize(value)
    @value = value
  end

  def win?(other_move)
    value && (other_move.value == 'paper' || other_move.value == 'spock')
  end
end

class Spock < Move
  def initialize(value)
    @value = value
  end

  def win?(other_move)
    value && (other_move.value == 'rock' || other_move.value == 'scissors')
  end
end

class Player
  attr_accessor :name, :move

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = ''
    loop do
      puts "Choose: #{Move::VALUES.join(', ')}"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Invalid input."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer, :score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = { human => 0, computer => 0 }
  end

  def display_welcome_message
    puts Move::VALUES.map(&:upcase).join(' ').to_s.center(45)
    puts ""
    puts "Welcome #{human.name}!".center(45)
    puts "First to 3 is the winner!".center(45)
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing! Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}".rjust(30)
    puts "#{computer.name} chose #{computer.move.value}".rjust(30)
    puts ""
  end

  def human_win?
    human.move.value.win?(computer.move.value)
  end

  def computer_win?
    computer.move.value.win?(human.move.value)
  end

  def display_winner
    if human_win?
      puts "#{human.name} won!"
    elsif computer_win?
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def score_increase
    if human_win?
      score[human] += 1
    elsif computer_win?
      score[computer] += 1
    end
  end

  def display_score
    puts ""
    puts "#{human.name}'s score: #{score[human]}".rjust(30)
    puts "#{computer.name}'s score: #{score[computer]}".rjust(30)
    puts ""
  end

  def clear_screen
    (system 'clear') || (system 'cls')
  end

  def play_again?
    return false if score.values.any? { |value| value > 2 }

    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer == 'n'
    return true if answer == 'y'
  end

  def play
    clear_screen
    display_welcome_message
    loop do
      human.choose
      computer.choose
      score_increase
      clear_screen
      display_moves
      display_winner
      display_score
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
