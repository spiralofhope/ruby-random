Display_invalid_codes = true

def colour_codes string
	require 'rubygems'
	require 'term/ansicolor' # http://term-ansicolor.rubyforge.org/
	include Term::ANSIColor

	# Gather an array of all the interesting text.
	text = []
	string.split(/@./).each { |element|
		text << element
	}
	# Because I was forced to make an empty array (text = []) I have to nuke the first item in it.  Wierd.
	text.shift
	# If no string is passed (only a colour code), use ""
	# This allows things like:  colour_codes("@w")
	if text == [] then text << "" end
	
	# Gather an array of all the interesting codes
	codes = string.scan(/@./)

	a = []
	text.each_index { |i|
		case codes[i]
		when "@R" then a[i] = red     + bold + text[i]
		when "@r" then a[i] = red            + text[i]
		when "@G" then a[i] = green   + bold + text[i]
		when "@g" then a[i] = green          + text[i]
		when "@B" then a[i] = blue    + bold + text[i]
		when "@b" then a[i] = blue           + text[i]
		when "@C" then a[i] = cyan    + bold + text[i]
		when "@c" then a[i] = cyan           + text[i]
		when "@M" then a[i] = magenta + bold + text[i]
		when "@m" then a[i] = magenta        + text[i]
		when "@Y" then a[i] = yellow  + bold + text[i]
		when "@y" then a[i] = yellow         + text[i]
		when "@W" then a[i] = white   + bold + text[i]
		when "@w" then a[i] = reset          + text[i] # "white" is "bold white".  "clear" and "reset" seem to be the same thing.
		when "@@" then a[i] = "@"            + text[i]
		else # If an invalid colour code has been found
			if Display_invalid_codes == true then
				print codes[i] + text[i] # Display invalid codes
			else
				print clear,     text[i] # Chop out invalid codes
			end
		end
	}
	# return my dummy array as a string, appending clear to avoid colour bleed:
	return a.join('') + clear
end

# Demonstration:
print colour_codes("@rred     @Rbold red\n")
print colour_codes("@ggreen   @Gbold green\n")
print colour_codes("@bblue    @Bbold blue\n")
print colour_codes("@ccyan    @Cbold cyan\n")
print colour_codes("@mmagenta @Mbold magenta\n")
print colour_codes("@yyellow  @Ybold yellow\n")
print colour_codes("@wwhite   @Wbold white\n")
print colour_codes("@w") # A single colour code can be passed.
print colour_codes("@@an at symbol @xan invalid code can be optionally displayed\n")



# Note
# if codes[i] == codes[i].upcase then bold else normal end
