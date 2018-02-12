# Behold this incomplete class for constructing boxed banners.

class Banner
  attr_reader :size

  def initialize(message)
    @message = message
    @size = message.size
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    '+' + '-' * (size + 2) + '+'
  end

  def empty_line
    '|' + ' ' * (size + 2) + '|'
  end

  def message_line
    "| #{@message} |"
  end
end
# Complete this class so that the test cases shown below work as intended.
# You are free to add any methods or instance variables you need. However,
# do not make the implementation details public.

# You may assume that the input will always fit in your terminal window.

# Test Cases

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+
banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+
