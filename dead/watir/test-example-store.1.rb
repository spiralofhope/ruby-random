# Includes
require 'Watir' # the watir controller
#include Watir

# Declare Variables
root =	'http://example.com/'			# store
welcome =	'http://example.com/welcome'
store =	'http://example.com/store'
ordering =	'http://example.com/ordering'
locations =	'http://example.com/locations'
contact =	'http://example.com/contact'

# Methods
# Go directly to a url, with stdout reporting
def goto(url)
	begin
		puts "* going to " + url
		$ie.goto(url)
	rescue
		puts ">>>ERROR"
	else
		puts "   ok, destination loads"
	end
	if $ie.url() == url
		puts "   ok, I stayed at the destination url"
	else
		puts "   warning: rewriting or redirection took effect"
	end
end

# Visit a specific link by specifying a url, with stdout reporting
def url(url)
	begin
		puts "* navigating to" + url
		#$ie.goto(url)
		$ie.link(:url, url).click
	rescue
		puts ">>>ERROR"
	else
		puts "   ok, link exists and destination loads"
	end
	if $ie.url() == url
		puts "   ok, I stayed at the destination url"
	else
		puts "   warning: rewriting or redirection took effect"
	end
end

# Search for text in a page
def search(string)
	puts "   searching for " + string
	if $ie.contains_text(string)
	   puts "   ok -- found " + string
	else
	   puts ">>>FAIL -- could not find " + string
	end
end

# Declare Variables
root =	'http://example.com/'			# store
welcome =	'http://example.com/welcome'
store =	'http://example.com/store'
ordering =	'http://example.com/ordering'
locations =	'http://example.com/locations'
contact =	'http://example.com/contact'

#$ie = Watir::IE.new	# or I could # $ie = Watir::ie.start(root)
$ie = Watir::IE.start("about:blank")
Watir::IE.minimize
#alt()   
#hasLoaded?()   

goto(root)
puts $ie.title()

# Wait for user input
puts "press <enter> to exit"
pause = gets

# Close the ie window
$ie.close()
