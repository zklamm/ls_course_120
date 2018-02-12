# Assume you have the following code:

class House
  attr_reader :price
  include Comparable

  def initialize(price)
    @price = price
  end

  def <=>(other_house)
    price <=> other_house.price
  end
end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1
# and this output:

# Home 1 is cheaper
# Home 2 is more expensive
# Modify the House class so that the above program will work.
# You are permitted to define only one new method in House.
