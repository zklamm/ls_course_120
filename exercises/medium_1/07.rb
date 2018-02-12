# In the previous exercise, you wrote a number guessing game that determines a
# secret number between 1 and 100, and gives the user 7 opportunities to guess
# the number.

# Update your solution to accept a low and high value when you create a
# GuessingGame object, and use those values to compute a secret number for the
# game. You should also change the number of guesses allowed so the user can
# always win if she uses a good strategy. You can compute the number of
# guesses with:

# Math.log2(size_of_range).to_i + 1

class GuessingGame
  attr_reader :range
  attr_accessor :guess_count, :guess, :answer

  def initialize(low, high)
    @range = (low..high)
    @guess_count = Math.log2(range.size).to_i + 1
    @answer = nil
    @guess = nil
    reset
  end

  def play
    reset
    until guess_count == 0
      display_remaining_guess_count
      player_guesses
      break if winner?
      display_accuracy
    end

    display_result
  end

  private

  def reset
    @answer = range.to_a.sample
    @guess = nil
  end

  def display_remaining_guess_count
    puts ""
    if guess_count == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{guess_count} guesses remaining."
    end
  end

  def player_guesses
    g = nil
    loop do
      print "Enter a number between #{range.first} and #{range.last}: "
      g = gets.to_i
      break if range.cover?(g)
      print "Invalid guess. "
    end
    self.guess = g
    self.guess_count -= 1
  end

  def winner?
    guess == answer
  end

  def display_accuracy
    if guess < answer
      puts "Your guess is too low"
    else
      puts "Your guess is too high"
    end
  end

  def display_result
    if winner?
      puts "You win!"
    else
      puts "You are out of guesses. You lose."
    end
  end
end

game = GuessingGame.new(501, 1500)
game.play
