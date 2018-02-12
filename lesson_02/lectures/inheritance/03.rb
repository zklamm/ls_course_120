class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Animal
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Animal
  def speak
    'meow!'
  end
end

# Draw a class hierarchy diagram of the classes from step #2

# Animal -> Object -> Kernel -> BasicObject
# Dog -> Animal -> Object -> Kernel -> BasicObject
# Car -> Animal -> Object -> Kernel -> BasicObject
