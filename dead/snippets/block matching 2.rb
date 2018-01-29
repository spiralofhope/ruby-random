# From a textfile, make two arrays. One is the matching block from [words] to [words] and one is everything BUT the matching block.

def create_sample_file(file)
file_contents = <<ENDTEXT
something
something else
 [no]
[false match
[true match]
the next line
hey
[ignore]]
[match]
something here too
this
ENDTEXT
	#Insert Desc_file_contents
	File.open(file, 'w+') do |f| # open file for update
		f.print file_contents      # write out the example description
	end                          # file is automatically closed
end

@@output = []
@@output2 = []
def get_it(file)
	match = false
	File.open(file, 'r+').each_with_index { |line,i|
		# Output the next line after a match.
		if line =~ /^\[[A-Za-z0-9 ]+\]$/ then
			match = !match
			if match == true then @@output << line.chomp ; next ; end
			if match == false then @@output2 << line.chomp ; next ; end
		end
		if match == true then @@output << line.chomp ; end
		if match == false then @@output2 << line.chomp ; end
	}
	return ""
end

create_sample_file("test_file")
puts get_it("test_file")
puts @@output
puts "----------"
puts @@output2
