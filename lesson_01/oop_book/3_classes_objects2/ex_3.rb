# When running the following code...

class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"

# We get the following error...

# test.rb:9:in `<main>': undefined method `name=' for
#   #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

# Why do we get this error and how to we fix it?

# We are getting this error because there is no setter method for 'name' defined.
# One way to fix this is to change 'attr_reader' to 'attr-accessor' or 'attr-writer'.
