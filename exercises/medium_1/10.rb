# In the previous two exercises, you developed a Card class and a Deck class.
# You are now going to use those classes to create and evaluate poker hands.
# Create a class, PokerHand, that takes 5 cards from a Deck of Cards and
# evaluates those cards as a Poker hand.

# You should build your class using the following code skeleton:

# Include Card and Deck classes from the last two exercises.

class Card
  include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def update_rank
    case rank.to_s[0]
    when 'A' then 14
    when 'K' then 13
    when 'Q' then 12
    when 'J' then 11
    else          rank
    end
  end

  def <=>(other)
    update_rank <=> other.update_rank
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = (2..10).to_a + %w[Jack Queen King Ace].freeze
  SUITS = %w[Hearts Clubs Diamonds Spades].freeze

  def initialize
    reset
  end

  def draw
    reset if @deck.empty?
    @deck.pop
  end

  private

  def reset
    @deck = RANKS.product(SUITS).shuffle.map do |rank, suit|
      Card.new(rank, suit)
    end
  end
end

class PokerHand
  def initialize(deck)
    @hand = []
    5.times { @hand << deck.draw }
  end

  def print
    puts @hand
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Style/EmptyCaseCondition
  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Style/EmptyCaseCondition

  private

  def royal_flush?
    royals = @hand.select do |card|
      card.rank == card.rank.to_s || card.rank == 10
    end
    royals.size == 5 && straight_flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    Deck::RANKS.each do |value|
      return true if @hand.map(&:rank).count(value) == 4
    end
    false
  end

  def full_house?
    pairs = 0
    triples = 0
    Deck::RANKS.each do |value|
      pairs += 1 if @hand.map(&:rank).count(value) == 2
      triples += 1 if @hand.map(&:rank).count(value) == 3
    end
    pairs == 1 && triples == 1
  end

  def flush?
    @hand.map(&:suit).uniq.size == 1
  end

  def straight?
    normalized = []
    @hand.sort.reverse.each_with_index do |card, idx|
      normalized << card.update_rank + idx
    end
    normalized.uniq.size == 1
  end

  def three_of_a_kind?
    Deck::RANKS.each do |value|
      return true if @hand.map(&:rank).count(value) == 3
    end
    false
  end

  def two_pair?
    pairs = 0
    Deck::RANKS.each do |value|
      pairs += 1 if @hand.map(&:rank).count(value) == 2
    end
    pairs == 2
  end

  def pair?
    Deck::RANKS.each do |value|
      return true if @hand.map(&:rank).count(value) == 2
    end
    false
  end
end

# Testing your class:

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
# rubocop:disable Style/Alias
class Array
  alias_method :draw, :pop
end
# rubocop:enable Style/Alias

# Test that we can identify each PokerHand type.

# rubocop:disable Style/IndentArray
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
# rubocop:enable Style/IndentArray

# Output:

# 5 of Clubs
# 7 of Diamonds
# Ace of Hearts
# 7 of Clubs
# 5 of Spades
# Two pair
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# true
# The exact cards and the type of hand will vary with each run.
