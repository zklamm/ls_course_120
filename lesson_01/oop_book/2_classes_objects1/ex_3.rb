# You want to create a nice interface that allows you to accurately describe
# the action you want your program to perform. Create a method called spray_paint
# that can be called on an object and will modify the color of the car.

class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def spray_paint(new_color)
    self.color = new_color
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

my_car = MyCar.new(2010, 'Silver', 'Honda Fit')
my_car.spray_paint('Blue')
p my_car.color
