# Create a class called MyCar. When you initialize a new instance or object
# of the class, allow the user to define some instance variables that tell
# us the year, color, and model of the car. Create an instance variable that
# is set to 0 during instantiation of the object to track the current speed
# of the car as well. Create instance methods that allow the car to speed up,
# brake, and shut the car off.

class MyCar
  # attr_accessor :speed

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def speed_up(num)
    @speed += num
  end

  def brake(num)
    @speed -= num
  end

  def shut_off
    @speed = 0
  end

  def current_speed
    @speed
  end
end

p my_car = MyCar.new(2010, 'Silver', 'Fit')
p my_car.speed_up(20)
p my_car.speed_up(14)
p my_car.brake(30)
my_car.shut_off
p my_car.current_speed
