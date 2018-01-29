begin
	require "Win32API"
	def read_char
		Win32API.new("crtdll", "_getch", [], "L").Call
	end
rescue LoadError
	def read_char
		system "stty raw -echo"
		STDIN.getc
	ensure
		system "stty -raw echo"
	end
end

i = 1
until i > 3
	# get a character
	a = read_char
	# 3 is for ^c
	# TODO: This may not be portable!
	if a == 3 then puts "aborting..." ; break end
	puts "I received:  " + a.to_s
	i = i + 1
end

puts "I'm done"

trap(:INT) {
	puts "got an interrupt -- doesn't work"
}
