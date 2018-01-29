#Intelligently convert a float into an integer:

a = 100.3
if a.ceil == a then
 puts "no denominator"
 a = a.to_i
else
 puts "denominator"
end
