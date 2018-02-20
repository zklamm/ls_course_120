require 'pry'

class Move
  MOVES = %w[Rock Paper Scissors Lizard Spock]
  ABBREVIATIONS = {
    'r' => 'rock',
    'p' => 'paper',
    'sc' => 'scissors',
    'l' => 'lizard',
    'sp' => 'spock'
  }

  attr_reader :move

  def initialize
    @move = self.class.to_s.downcase
  end

  def ==(other)
    move == other.move
  end

  def to_s
    move
  end
end

class Rock < Move
  def >(other)
    other.move == 'scissors' || other.move == 'lizard'
  end
end

class Paper < Move
  def >(other)
    other.move == 'spock' || other.move == 'rock'
  end
end

class Scissors < Move
  def >(other)
    other.move == 'paper' || other.move == 'lizard'
  end
end

class Lizard < Move
  def >(other)
    other.move == 'paper' || other.move == 'spock'
  end
end

class Spock < Move
  def >(other)
    other.move == 'scissors' || other.move == 'rock'
  end
end

class History
  attr_accessor :list

  def initialize
    @list = []
  end

  def add_to_list(choice)
    @list << choice
  end

  def to_s
    @list.join(', ')
  end
end

class Player
  attr_accessor :choice, :name, :score, :history

  def initialize
    @choice = ''
    @name = ''
    @score = 0
    @history = History.new
  end

  def make_choice(choice)
    case choice
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
  end
end

class Human < Player
  def determine_name
    answer = ''
    loop do
      puts "What is your name?"
      answer = gets.strip
      break unless answer.empty?
      puts "You must enter a name."
    end
    self.name = answer
  end

  def valid_choice?(choice)
    Move::MOVES.map(&:downcase).include?(choice) ||
      Move::ABBREVIATIONS.keys.include?(choice)
  end

  def abbreviation?(word)
    Move::ABBREVIATIONS.keys.include?(word)
  end

  def convert_abbreviations(abbr)
    Move::ABBREVIATIONS[abbr]
  end

  def move
    answer = ''
    loop do
      puts "Choose one: #{Move::MOVES.join(', ')}"
      puts "(#{Move::ABBREVIATIONS.keys.join(', ')})"
      answer = gets.chomp.downcase
      break if valid_choice?(answer)
      puts "Invalid choice."
    end
    answer = convert_abbreviations(answer) if abbreviation?(answer)
    self.choice = make_choice(answer)
  end
end

class Computer < Player
  attr_accessor :choice_pool

  def initialize
    @choice_pool = Move::MOVES.map(&:downcase)
    super
  end

  def determine_name
    self.name = ['Chappie', 'Sonny', 'Number 5'].sample
  end

  def move
    self.choice = make_choice(choice_pool.sample)
  end

  def update_choice_pool(human_choice)
    case human_choice.to_s
    when 'rock' then choice_pool.push('spock', 'paper')
    when 'paper' then choice_pool.push('lizard', 'scissors')
    when 'scissors' then choice_pool.push('spock', 'rock')
    when 'lizard' then choice_pool.push('rock', 'scissors')
    when 'spock' then choice_pool.push('paper', 'lizard')
    end
  end
end

class R2D2 < Computer
  def determine_name
    self.name = 'R2D2'
  end

  def move
    self.choice = make_choice('rock')
  end
end

class Hal < Computer
  def determine_name
    self.name = 'Hal'
  end

  def move
    moves = [
      'rock',
      'scissors', 'scissors', 'scissors', 'scissors', 'scissors',
      'lizard', 'lizard',
      'spock', 'spock'
    ]
    self.choice = make_choice(moves.sample)
  end
end

class RPS
  MAX_SCORE = 3

  attr_reader :human, :computer

  def initialize
    @human = Human.new
    @computer = [Computer, R2D2, Hal].sample.new
  end

  def play
    display_welcome_message
    determine_names
    display_opponent
    loop do
      make_moves
      display_results
      update_computer_choices
      break if max_score_met?
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def clear_screen
    (system 'cls') || (system 'clear')
  end

  def display_rules
    puts ""
    puts "Rules:"
    puts ""
    puts "Scissors cuts Paper covers Rock crushes Lizard\npoisons Spock "\
    "smashes Scissors decapitates Lizard\neats Paper disproves "\
    "Spock vaporizes Rock crushes\nScissors."
    puts ""
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to #{Move::MOVES.join('-')}!"
    display_rules
    puts "The first to #{MAX_SCORE} points wins!"
    puts ""
    puts "Hit 'enter' to continue."
    gets
  end

  def determine_names
    clear_screen
    human.determine_name
    computer.determine_name
  end

  def display_opponent
    clear_screen
    puts "You will be playing #{computer.name}."
    puts ""
    puts "Hit 'enter' to begin!"
    gets
  end

  def make_moves
    clear_screen
    human.move
    computer.move
  end

  def display_choices
    puts ""
    puts "#{human.name} chose: #{human.choice}"
    puts "#{computer.name} chose: #{computer.choice}"
    puts ""
  end

  def determine_winner
    return :tie if human.choice == computer.choice
    human.choice > computer.choice ? :human : :computer
  end

  def display_winner
    case determine_winner
    when :tie      then puts "It's a tie!"
    when :human    then puts "#{human.name} won!"
    when :computer then puts "#{computer.name} won!"
    end
  end

  def increase_score
    case determine_winner
    when :human then human.score += 1
    when :computer then computer.score += 1
    end
  end

  def display_score
    puts ""
    puts "#{human.name}'s score: #{human.score}"
    puts "#{computer.name}'s score: #{computer.score}"
  end

  def add_history
    human.history.add_to_list(human.choice)
    computer.history.add_to_list(computer.choice)
  end

  def display_history
    puts ""
    puts "#{human.name}'s move history:"
    puts human.history.to_s
    puts ""
    puts "#{computer.name}'s move history:"
    puts computer.history.to_s
    puts ""
  end

  def display_results
    display_choices
    determine_winner
    display_winner
    increase_score
    display_score
    add_history
    display_history
  end

  def update_computer_choices
    return unless human.choice > computer.choice
    computer.update_choice_pool(human.choice)
  end

  def max_score_met?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def play_again?
    puts ""
    answer = ''
    puts "Play again? Enter 'y' or 'n'"
    loop do
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Must enter 'y' or 'n'"
    end
    answer == 'y'
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing! Goodbye!"
  end
end

RPS.new.play
