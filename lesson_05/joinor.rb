# Write a method called joinor that will produce the following result:

# input: array of arbitrary elements
# output: string of elements delimited with ', ' and an 'or' for last element
# if there are greater than two elements
# logic:
#         if input size is greater than 2, join all elements except the last
#         one, add ', or ' and final element
#         else join both elements with ', '

def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end

p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
