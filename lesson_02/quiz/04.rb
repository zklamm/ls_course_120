# Examine the following code:

class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

sir_gallant = Knight.new("Gallant")
p sir_gallant.name # => "Sir Gallant"
p sir_gallant.speak # => "Sir Gallant is speaking."

# You must make some changes to the above code so that the last two
# statements return the values shown in the comments. Which of the
# following changes do you need to make? (You may need to make more than one change).
