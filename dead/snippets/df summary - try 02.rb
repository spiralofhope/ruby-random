#!/usr/bin/env ruby

=begin
On OS X

I can't specify output in bytes on OS X, so I'll fake it with df -b and multiply the block count by 512.

On OS X the first column has spaces in it, so I look for the first set of digits which are surrounded by space as the blocks used value
=end


def human_readable(number, type)
	# Do some math then return the number in a commified form:
	return (number/type).to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
end


output_original = %x{#{"df -B 1"}}.split("\n")

output_column3 = []
output_original.each_with_index { |ignored,i|
	if i == 0 then next end
	output_column3 << output_original[i].split(" ", 0)[2].chomp
}

summary = 0
# Tally up each row, converting it into a number:
output_column3.each { |i|
	summary = summary + i.to_i
}
# puts summary
# Human-readable output:
puts "== Total space used:  "
print human_readable(summary, 1)
puts "  B"

print " " * 4
print human_readable(summary, 1000)
puts " kB"

print " " * 8
print human_readable(summary, 1000000)
puts " MB"

print " " * 12
print human_readable(summary, 1000000000)
puts " GB"

__END__

NOTES:

* This counts 1k as 1024 bytes.

ISSUES:

* This will tally up everything, so if you have the same thing mounted twice, it'll get counted twice.
