# Move all of the methods from the MyCar class that also pertain to the MyTruck
# class into the Vehicle class. Make sure that all of your previous method
# calls are working when you are finished.

module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

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
  include Towable

  NUM_OF_DOORS = 2

  def to_s
    "My truck is a #{color} #{model} from #{year}."
  end
end

car = MyCar.new(2010, 'silver', 'Honda Fit')
truck = MyTruck.new(2018, 'maroon', 'Toyota Tundra')

puts truck.current_speed
truck.speed_up(50)
truck.brake(20)
puts truck.current_speed
