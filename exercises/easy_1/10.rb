# Consider the following classes:

class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  NUM_WHEELS = 4
end

class Motorcycle < Vehicle
  NUM_WHEELS = 2
end

class Truck < Vehicle
  NUM_WHEELS = 6

  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end
end
# Refactor these classes so they all use a common superclass, and inherit behavior as needed.
