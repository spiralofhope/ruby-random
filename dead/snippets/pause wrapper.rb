=begin
I created this so that I could use the Kate editor for Ruby scripting. I could bind a hotkey to run my ruby script in an xterm console and with this wrapper I can ensure that the console will stay open until I press enter.

See kate and ruby:
http://blog.spiralofhope.com/?p=24548

=end


begin

def help
# FIXME clear the screen
help = <<ENDTEXT
== Synopsis

Run a ruby script and ensure a pause at its completion.

== Usage

   ruby #{$0} <script> [parameters]

ENDTEXT

puts help
end

if ARGV == [] then help ; exit end
if File.exists?(ARGV[0]) == false then help ; puts "ERROR: #{ARGV[0]} does not exist" ; exit end

# Convert the arguments array into a string:
arg_string = ""
ARGV.each {|arg| arg_string = arg_string + " " + arg }

# launch $1, passing all additional parameters
Kernel::fork do
	Kernel::exec "ruby #{arg_string}"
end
Process.wait

# TODO: This does not work:
# ruby $0 subdirectory/script.rb parameters
# Must be fixed so that ARGV[0] is understood, and any directories are CDed into before the script is exec-ed.

# Rescue error messages, so that the following "ensure" will succeed
rescue => my_error_message
	puts my_error_message
else
	# no errors
ensure
	puts "<PAUSED>"
	ARGV.clear
	ARGV << gets
end
