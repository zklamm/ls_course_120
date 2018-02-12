# Add a class method to your MyCar class that calculates the gas mileage of any car.

class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
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
p MyCar.calculate_gas_mileage(100, 3)
