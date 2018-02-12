# Examine the following code:

class Cat
  attr_reader :name

  @@total_cats = 0

  def initialize(name)
    @name = name
    @@total_cats += 1
  end

  def jump
    "#{name} is jumping!"
  end

  def self.total_cats
    @@total_cats
  end

  def to_s
    name
  end
end

mitzi = Cat.new('Mitzi')
p mitzi.jump # => "Mitzi is jumping!"
p Cat.total_cats # => 1
p "The cat's name is #{mitzi}" # => "The cat's name is Mitzi"

# You must make some changes to the above code so that the last three statements
# return the values shown in the comments. Which of the following changes do you
# need to make? (You may need to make more than one change).
