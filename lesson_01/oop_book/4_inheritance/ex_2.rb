# Add a class variable to your superclass that can keep track of the number
# of objects created that inherit from the superclass. Create a method to
# print out the value of this class variable as well.

class Vehicle
  @@num_of_vehicles = 0

  attr_accessor :color, :model
  attr_reader :year

  def initialize(y, c, m)
    @@num_of_vehicles += 1
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def self.print_vehicle_num
    puts "There are #{@@num_of_vehicles} vehicles."
  end

  def self.gas_mileage(miles, gallons)
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
Vehicle.print_vehicle_num
