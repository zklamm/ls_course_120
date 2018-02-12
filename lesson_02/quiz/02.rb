# Examine the following Ruby code:

class Student
  attr_accessor :grade

  def initialize(name, grade=nil)
    @name = name
  end
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">

# Which of the following code snippets can you add to the class body
# so that the above code returns a Student object whose state matches
# the comment in the last line shown above? Select all that apply.
