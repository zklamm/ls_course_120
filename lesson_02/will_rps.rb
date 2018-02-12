THIN_DIVIDER =  "----------------------------"
THICK_DIVIDER = '============================'

class Move
  attr_accessor :value
  VALUES = ['rock', 'paper', 'scissor', 'spock', 'lizard']

  def initialize(value)
    @value = case value
             when 'rock' then Rock.new('rock')
             when 'paper' then Paper.new('paper')
             when 'scissor' then Scissor.new('scissor')
             when 'spock' then Spock.new('spock')
             else
               Lizard.new('lizard')
             end
  end

  WIN_HASH = {
    'rock' => %w[scissor lizard],
    'paper' => %w[rock spock],
    'scissor' => %w[paper lizard],
    'lizard' => %w[paper spock],
    'spock' => %w[rock scissor]
  }

  def >(other_move)
    WIN_HASH[value].include?(other_move.value)
  end

  def <(other_move)
    other_move > self
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize(value)
    @value = value
  end
end

class Paper < Move
  def initialize(value)
    @value = value
  end
end

class Scissor < Move
  def initialize(value)
    @value = value
  end
end

class Spock < Move
  def initialize(value)
    @value = value
  end
end

class Lizard < Move
  def initialize(value)
    @value = value
  end
end

class Player
  attr_accessor :move, :name, :wins

  def initialize
    @wins = 0
  end

  def tally
    puts "#{name}: #{wins}".rjust(15)
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts THIN_DIVIDER
      puts "Please state your name"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, you must enter a value."
    end
    self.name = n
  end

  def choice_prompt
    puts <<-MSG
Please select one of the following:
'r'  = Rock
'p'  = Paper
'sc' = Scissor
'sp' = Spock
'l'  = Lizard
('q' to quit)
    MSG
  end

  def choose
    choice_converter = { 'r' => 'rock',
                         'sc' => 'scissor',
                         'p' => 'paper',
                         'l' => 'lizard',
                         'sp' => 'spock' }
    choice = nil
    loop do
      choice_prompt
      choice = gets.downcase.chomp
      return false if choice == 'q'
      choice = choice_converter[choice]
      break if Move::VALUES.include?(choice)
      puts "Sorry. Invalid choice."
    end
    self.move = Move.new(choice).to_s
  end
end

class Computer < Player
  attr_accessor :rock_array, :paper_array, :scissor_array, :spock_array,
                :lizard_array, :sample_population, :comp_history

  def initialize
    super
    @rock_array = Array.new(40, 'rock')
    @paper_array = Array.new(40, 'paper')
    @scissor_array = Array.new(40, 'scissor')
    @spock_array = Array.new(40, 'spock')
    @lizard_array = Array.new(40, 'lizard')
    @sample_population = [rock_array, paper_array, scissor_array,
                          spock_array, lizard_array]
    @comp_history = { 'rock' => { attempts: 0, wins: 0, losses: 0, ties: 0 },
                      'paper' => { attempts: 0, wins: 0, losses: 0, ties: 0 },
                      'scissor' => { attempts: 0, wins: 0, losses: 0, ties: 0 },
                      'spock' => { attempts: 0, wins: 0, losses: 0, ties: 0 },
                      'lizard' => { attempts: 0, wins: 0, losses: 0, ties: 0 } }
  end

  def set_name
    decepticon = ['Shockwave', 'Ratbat', 'Starscream', 'Megatron'].sample
    self.name = case decepticon
                when 'Megatron' then Megatron.new
                when 'Shockwave'then Shockwave.new
                when 'Ratbat' then Ratbat.new
                else Starscream.new
                end
  end

  def choose
    self.move = Move.new(name.sample_population.flatten.sample).to_s
  end

  def update_comp_history(round_winner)
    suit = move.to_s
    name.comp_history[suit][:attempts] += 1
    update_suit_scores(round_winner, suit)
    name.adjust_weighting?(round_winner, suit) unless name.class == Ratbat
  end

  def update_suit_scores(round_winner, suit)
    case round_winner
    when name.to_s then name.comp_history[suit][:wins] += 1
    when 'tie' then name.comp_history[suit][:ties] += 1
    else
      name.comp_history[suit][:losses] += 1
    end
  end
end

# Starscream will not change a winning or tying hand, meaning no change in
# weighting.For a losing hand, he'll evaluate if that suit has lost more than
# or equal to 60 % of attempts,in which case he reduces its count in the sample
# population by four and adds one to the others. He will, however, maintain a
# minimum count of five for each suit (out of 200 in the sample population).
class Starscream < Computer
  def initialize
    super
    @value = "Starscream"
  end

  def to_s
    @value
  end

  def adjust_weighting?(round_winner, move)
    return unless !["Starscream", 'tie'].include?(round_winner) &&
                  sample_population.flatten.count(move) >= 5 &&
                  comp_history[move][:losses] /
                  comp_history[move][:attempts].to_f >= 0.60
    decrease_weighting(move)
  end
  def decrease_weighting(move)
    case move
    when 'rock' then rock_array.slice!(0..4)
    when 'paper' then paper_array.slice!(0..4)
    when 'scissor' then scissor_array.slice!(0..4)
    when 'spock' then spock_array.slice!(0..4)
    else lizard_array.slice!(0..4)
    end
    restore_sample_population_size
  end
  def restore_sample_population_size
    sample_population.each do |suit_array|
      suit_array.push(suit_array.first)
    end
  end
end
# Megatron is a contrarian. He'll add to losing suits believing that wins and
# and losses for each suit will cancel out, so that that odds of winning for
# a suit is greater after a loss.
# He also maintain a five count minimum for each suit.
class Megatron < Computer
  def initialize
    super
    @value = "Megatron"
  end
  def to_s
    @value
  end
  def adjust_weighting?(round_winner, move)
    return unless sample_population.flatten.count(move) >= 5 &&
                  !["Starscream", 'tie'].include?(round_winner)
    increase_weighting(move)
  end
  def increase_weighting(move)
    case move
    when 'rock' then 5.times { rock_array << 'rock' }
    when 'paper' then 5.times { paper_array << 'paper' }
    when 'scissor' then 5.times { scissor_array << 'scissor' }
    when 'spock' then 5.times { spock_array << 'spock' }
    else 5.times { lizard_array << 'lizard' }
    end
    restore_sample_population_size
  end
  def restore_sample_population_size
    sample_population.each(&:pop)
  end
end
# Shockwave doesn't waste paper as it's not very Decepticon-like
# to use paper when there are rocks and lizards at one's disposal.
# Furthermore, in the beginning, he's twice as likely to use rocks as any of
# the remaining three.As the game progresses, he increase the lizard count in
# the sample population by two for each round, believing that frail, mortal
# humans will gravitate towards paper and spock as they mentally tire.
class Shockwave < Computer
  def initialize
    super
    @value = "Shockwave"
    sample_population.delete(paper_array)
    sample_population.push(rock_array)
  end
  def to_s
    @value
  end
  def adjust_weighting?(_, _)
    2.times { sample_population << "lizard" }
  end
end
# Ratbat has statistical intuition. He understands the randomness of the game
# and smirks at the other Decepticons who believe that there are patterns to be
# studied, and that odds of winning can be increased by adjusting the weighting
# of each suit according to said pattern. He therefore tosses a coin each time
# and maintains a 20 percent equal weighting of each suit.
class Ratbat < Computer
  def initialize
    super
    @value = "Ratbat"
  end
  def to_s
    @value
  end
end
class RoundWinner
  attr_accessor :status
end
class Round
  attr_accessor :number
  def initialize
    @number = 1
  end
end
class History
  attr_accessor :array
  def initialize(ary)
    @array = ary
  end
  def output
    puts THIN_DIVIDER
    array.each_with_index do |i, indx|
      if i.size > 2
        puts "Round #{indx + 1}: #{i[0]} won. #{i[1].capitalize} beat #{i[2]}."
      else
        puts "Round #{indx + 1}: #{i[0]}. Both chose #{i[1]}."
      end
    end
  end
end
class RPSGame
  attr_reader :human, :computer, :round_winner, :round, :history
  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_winner = RoundWinner.new
    @round = Round.new
    @history = History.new([])
  end
  def reinitialize
    @computer = Computer.new
    @round_winner = RoundWinner.new
    @round = Round.new
    @history = History.new([])
    human.wins = 0
  end
  def display_welcome_message
    puts "Welcome to Rock-Paper-Scissor-Spock-Lizard."
    puts "The first to win 10 rounds wins the game."
    establish_names
  end
  def establish_names
    human.set_name unless human.name
    computer.set_name
  end
  def display_round_number
    puts THICK_DIVIDER
    puts "Round #{round.number}".rjust(18)
  end
  def players_choose_suit
    computer.choose
    human.choose
  end
  def evaluate_round_winner
    round_winner.status = if human.move > computer.move
                            human.name
                          elsif computer.move > human.move
                            computer.name.to_s
                          else
                            'tie'
                          end
    update_game_history
  end
  def update_game_history
    human_name = human.name
    computer_name = computer.name.to_s
    human_move = human.move.to_s
    computer_move = computer.move.to_s
    round_winner_status = round_winner.status
    history.array << case round_winner_status
                     when human_name
                       [human_name, human_move, computer_move]
                     when computer_name
                       [computer_name, computer_move, human_move]
                     else
                       ["It was a tie", human_move]
                     end
    update_score
  end
  def update_score
    case round_winner.status
    when human.name
      human.wins += 1
    when computer.name.to_s
      computer.wins += 1
    end
    round.number += 1
    computer.update_comp_history(round_winner.status)
  end
  def declare_round_winner
    latest_round_outcome = round_winner.status
    puts THIN_DIVIDER
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
    if latest_round_outcome == "tie"
      puts "= It's a tie"
    else
      puts "= #{latest_round_outcome} wins the round"
    end
  end
  def display_score
    puts THIN_DIVIDER
    puts "The score is:"
    human.tally
    computer.tally
  end
  def game_winner?
    human.wins == 10 || computer.wins == 10
  end
  def declare_game_winner
    puts THICK_DIVIDER
    puts "#{round_winner.status} WINS THE GAME!".center(30) if game_winner?
    puts "The final score is".center(30)
    human.tally
    computer.tally
    puts
  end
  def offer_history_account
    puts "Would you like to see a history of the game? (y/n)"
    answer = ''
    loop do
      answer = gets.downcase.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, please select a valid input (y/n)"
    end
    history.output if answer == 'y'
  end
  def play_again?
    puts THICK_DIVIDER
    puts "Would you like to play again? (y/n)"
    answer = ''
    loop do
      answer = gets.downcase.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, please select a valid input (y/n)"
    end
    return false if answer == 'n'
    reinitialize
    true
  end
  def print_goodbye_message
    puts THIN_DIVIDER
    puts "Thank you for playing Rock-Paper-Scissor-Spock-Lizard"
    puts "Have a nice day!"
  end
  def play
    loop do # game loop
      display_welcome_message
      loop do # round loop
        display_round_number
        break unless players_choose_suit
        evaluate_round_winner
        declare_round_winner
        break if game_winner?
        display_score
      end
      declare_game_winner
      offer_history_account
      break unless play_again?
    end
    print_goodbye_message
  end
end
RPSGame.new.play
