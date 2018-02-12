# Override the to_s method to create a user friendly print out of your object.

class MyCar
  attr_accessor :color, :model
  attr_reader :year

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def to_s
    "My car is a #{color} #{model} from #{year}."
  end

  def self.calculate_gas_mileage(miles, gallons)
    miles / gallons
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
puts my_car.to_s
