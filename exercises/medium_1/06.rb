# Create an object-oriented number guessing class for numbers in the range 1
# to 100, with a limit of 7 guesses per game.

class GuessingGame
  RANGE = 1..100
  GUESSES_PER_GAME = 7

  attr_accessor :guess_count, :guess, :answer

  def initialize
    @answer = nil
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
    @answer = RANGE.to_a.sample
    @guess_count = GUESSES_PER_GAME
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
      print "Enter a number between #{RANGE.first} and #{RANGE.last}: "
      g = gets.to_i
      break if RANGE.cover?(g)
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

game = GuessingGame.new
game.play
game.play
