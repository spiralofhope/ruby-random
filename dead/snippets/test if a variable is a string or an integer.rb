# Get a string from the user
puts "Enter a string"
input = gets.chomp
# Learn what type it is (.class)

# user types 0
if input == "0"
then
  input = input.to_i    # => 0
elsif input.to_i == 0
  # User typed a string
  # .. do nothing
elsif input.to_i != 0  # User typed a number
  input = input.to_i
end
# TODO: The user could give a mixed number-string combination.. to_i disregards the string part..


if input.class == Fixnum   #Tests what it is <class>
then
  # It's a number
  # If it's a number, do some math on it, like 1000 - input
  puts 1000 - input
elsif input.class == String
  # It's not a number
  # Put it in a phrase, like "hello, yourname"
  puts "hello, " + input
end

puts "Press enter to exit."
pause = gets
