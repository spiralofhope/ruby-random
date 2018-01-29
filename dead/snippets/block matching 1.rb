#From a textfile, seek to [word] and output the next line.

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

def get_it(file)
	match = false
	File.open(file, 'r+').each_with_index { |line,i|
		# Output the next line after a match.
		if match == true then puts line ; match = false ; end
		if line =~ /^\[[A-Za-z0-9 ]+\]$/ then
			match = true
			puts i.to_s + " -- " + line.chomp
		end
	}
	return ""
end

create_sample_file("test_file")
puts get_it("test_file")
