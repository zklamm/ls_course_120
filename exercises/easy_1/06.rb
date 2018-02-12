# Consider the following class definition:

class Flight
  attr_accessor :database_handle # delete this line

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end
# There is nothing technically incorrect about this class, but the
# definition may lead to problems in the future. How can this class
# be fixed to be resistant to future problems?

# Delete line 4, no need to provide access to this instance variable
