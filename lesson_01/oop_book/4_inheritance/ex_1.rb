# Create a superclass called Vehicle for your MyCar class
# to inherit from and move the behavior that isn't specific
# to the MyCar class to the superclass. Create a constant in
# your MyCar class that stores information about the vehicle
# that makes it different from other types of Vehicles.

# Then create a new class called MyTruck that inherits from
# your superclass that also has a constant defined that separates
# it from the MyCar class in some way.

class Vehicle
  def self.calculate_gas_mileage(miles, gallons)
    miles / gallons
  end

  attr_accessor :color, :model
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

class MyCar < Vehicle
  NUM_OF_DOORS = 4

  def to_s
    "My car is a #{color} #{model} from #{year}."
  end
end

class MyTruck < Vehicle
  NUM_OF_DOORS = 2

  def to_s
    "My truck is a #{color} #{model} from #{year}."
  end
end

car = MyCar.new(2010, 'silver', 'Honda Fit')
truck = MyTruck.new(2018, 'maroon', 'Toyota Tundra')

puts car
puts truck
