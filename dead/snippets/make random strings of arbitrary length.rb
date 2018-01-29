class Numeric 
  def random_string
    (1..self).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join
  end
end

# Usage
=begin
22.random_string
>> 22.random_string       
=> "3gLhOCs85m5AobPuMAYgmh"
=end
