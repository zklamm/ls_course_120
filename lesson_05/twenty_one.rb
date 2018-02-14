class Participant
  attr_accessor :hand, :score

  def initialize
    @hand = []
    @score = 0
  end

  def num_of_aces
    aces = 0
    hand.each do |card|
      aces += 1 if card.rank == 'A'
    end
    aces
  end

  def total
    sum = 0
    hand.each do |card|
      sum += Deck::VALUES[card.rank]
    end
    sum > 21 ? sum - (10 * num_of_aces) : sum
  end

  def busted?
    total > 21
  end

  def increase_score
    self.score += 1
  end
end

class Player < Participant
  attr_accessor :choice

  def initialize
    @choice = ''
    super
  end

  def choose_hit_or_stay
    answer = ''
    puts "Hit or stay? Enter 'h' or 's'"
    loop do
      answer = gets.chomp.downcase
      break if %w[h s].include?(answer)
      puts "Please enter 'h' or 's'"
    end
    self.choice = answer
  end

  def stay?
    choice == 's'
  end

  def hit?
    choice == 'h'
  end
end

class Deck
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  SUITS = %w[(♠) (♥) (♦) (♣)]
  FULL_DECK = RANKS.product(SUITS)
  VALUES = {
    '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
    '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10,
    'Q' => 10, 'K' => 10, 'A' => 11
  }

  attr_reader :cards

  def initialize
    @cards = FULL_DECK.map do |rank, suit|
      Card.new(rank, suit)
    end
    @cards.shuffle!
  end

  def deal
    cards.pop
  end
end

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank}#{suit}"
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Participant.new
    reset
  end

  def start
    display_welcome_message
    loop do
      starting_sequence
      player_sequence
      dealer_sequence
      display_result unless player.busted?
      display_score
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def reset
    @deck = Deck.new
    player.hand = []
    dealer.hand = []
    player.choice = ''
  end

  def clear_screen
    (system 'clear') || (system 'cls')
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to Twenty-One!"
    puts ""
    puts "Press 'enter' to begin"
    gets
  end

  def deal_cards
    2.times { player.hand << deck.deal }
    2.times { dealer.hand << deck.deal }
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[0..-2].join(delimiter) + "#{delimiter}#{word} " + arr[-1].to_s
    end
  end

  def display_initial_hands
    puts "Dealer has: #{dealer.hand.first} & ??? = ???"
    puts ""
    puts "You have: #{joinor(player.hand, ', ', '&')} = #{player.total}"
    puts ""
    puts ""
  end

  def starting_sequence
    reset
    clear_screen
    deal_cards
    display_initial_hands
  end

  def player_turn
    player.choose_hit_or_stay
    player.hand << deck.deal if player.hit?
    clear_screen
    display_initial_hands
    dealer.increase_score if player.busted?
  end

  def player_sequence
    player_turn until player.busted? || player.stay?
  end

  def dealer_turn
    dealer.hand << deck.deal
  end

  def dealer_win?
    dealer.total > player.total
  end

  def dealer_stop_conditions
    dealer.busted? || dealer_win? || dealer.total > 16
  end

  def dealer_sequence
    return puts "Busted! Too bad! Dealer wins!" if player.busted?
    dealer_turn until dealer_stop_conditions
    player.increase_score if dealer.busted?
  end

  def determine_winner
    case player.total <=> dealer.total
    when 1
      puts "You win!"
      player.increase_score
    when -1
      puts "Dealer wins!"
      dealer.increase_score
    else
      puts "It's a tie!"
    end
  end

  def display_final_hands
    puts "Dealer has: #{joinor(dealer.hand, ', ', '&')} = #{dealer.total}"
    puts ""
    puts "You have: #{joinor(player.hand, ', ', '&')} = #{player.total}"
    puts ""
    puts ""
  end

  def display_dealer_action
    num_of_hits = dealer.hand.size - 2
    case num_of_hits
    when 0 then puts "The dealer stays..."
    when 1 then puts "The dealer hit 1 time..."
    else        puts "The dealer hit #{num_of_hits} times..."
    end
  end

  def display_result
    clear_screen
    display_final_hands
    display_dealer_action
    if dealer.busted?
      puts "Dealer busted! You win!"
    else
      determine_winner
    end
  end

  def display_score
    puts ""
    puts "  Your score: #{player.score}"
    puts "Dealer score: #{dealer.score}"
    puts ""
  end

  def play_again?
    answer = ''
    puts ""
    puts "Play again? Enter 'y' or 'n'"
    loop do
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Please enter 'y' or 'n'"
    end
    answer == 'y'
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Twenty-One! Goodbye!"
  end
end

Game.new.start
