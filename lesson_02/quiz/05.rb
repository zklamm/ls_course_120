# Let's add a Thief class as a descendant of Character. Examine the following code:

class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} is speaking."
  end
end

class Thief < Character
  def speak
    "#{name} is whispering..."
  end
end

sneak = Thief.new("Sneak")
p sneak.name # => "Sneak"
p sneak.speak # => "Sneak is whispering..."

# You must make some changes to the above code so that the last two
# statements return the values shown in the comments. Which of the
# following changes do you need to make?
