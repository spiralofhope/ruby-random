#!/usr/bin/env ruby

def exec_and_return_output(*args)
		if fd = IO.popen('-') then
	output = fd.readlines
		else
	exec *args
		end
		return output
end

exec_output_array = exec_and_return_output("df -B 1")

output = []
for i in 1..exec_output_array.rindex(exec_output_array.last) do
	# Note: This would probably explode if a device name had a space in its path.
	# Capture the first column:
	# output << exec_output_array[i].split(" ", 0)[1].chomp
	# Capture the second column
	output << exec_output_array[i].split(" ", 0)[2].chomp
end

summary_B = 0
# Tally up each row, converting it into a number:
output.each { |i|
	summary_B = summary_B + i.to_i
}
# puts summary
# Human-readable output:
puts "== Total space used:  "
puts summary_B.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2') + " B"

summary_k = summary_B.to_f/1000
# Round up
summary_k = summary_k.ceil
puts "    " + summary_k.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2') + " kB"

summary_M = summary_B.to_f/1000000
# Round up
summary_M = summary_M.ceil
puts "        " + summary_M.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2') + " MB"

summary_G = summary_B.to_f/1000000000
# Round up
summary_G = summary_G.ceil
puts "            " + summary_G.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2') + " GB"

__END__

NOTES:

* This counts 1k as 1024 bytes.

ISSUES:

* This will tally up everything, so if you have the same thing mounted twice, it'll get counted twice.
