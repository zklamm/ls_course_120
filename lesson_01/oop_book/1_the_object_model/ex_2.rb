# What is a module? What is its purpose? How do we use them with our classes?
# Create a module for the class you created in exercise 1 and include it properly.

# A module is a collection of behaviors that can be passed to a class or classes.
# It's purpose is to make characteristics available to multiple classes.
# To use a module in a class, we have to mix it in by calling the include method.

module ThumbsUp
end

module Hello
  class ZacClass
    include ThumbsUp
  end
end

zac = Hello::ZacClass.new

puts Hello::ZacClass.ancestors
