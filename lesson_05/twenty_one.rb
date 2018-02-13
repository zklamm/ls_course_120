class Participant
  attr_accessor :hand

  def initialize
    @hand = []
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
end

class Player < Participant
  def choice
    answer = ''
    puts "Hit or stay? Enter 'h' or 's'"
    loop do
      answer = gets.chomp.downcase
      break if %w[h s].include?(answer)
      puts "Please enter 'h' or 's'"
    end
    answer
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

  attr_reader :deck

  def initialize
    @deck = FULL_DECK.map do |rank, suit|
      Card.new(rank, suit)
    end
    @deck.shuffle!
  end

  def deal
    deck.pop
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
    reset
  end

  def start
    display_welcome_message
    loop do
      starting_sequence
      player_sequence
      dealer_sequence
      display_result unless player.busted?
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def reset
    @deck = Deck.new
    @player = Player.new
    @dealer = Participant.new
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
    player.hand << deck.deal if player.hit?
    clear_screen
    display_initial_hands
    puts "Busted! Too bad! Dealer wins!" if player.busted?
  end

  def player_sequence
    loop do
      player_turn
      break if player.busted? || player.stay?
    end
  end

  def dealer_turn
    dealer.hand << deck.deal if dealer.total < 17
  end

  def dealer_win?
    dealer.total >= 17 || dealer.total > player.total
  end

  def dealer_sequence
    return if player.busted?
    dealer_turn until dealer.busted? || dealer_win?
  end

  def determine_winner
    case player.total <=> dealer.total
    when 1  then puts "You win!"
    when -1 then puts "Dealer wins!"
    else         puts "It's a tie!"
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
    when 0 then puts "The dealer stays."
    when 1 then puts "The dealer hit 1 time."
    else        puts "The dealer hit #{num_of_hits} times."
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
