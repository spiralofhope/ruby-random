# For http://example.com/

# Section 1: Comments
#-------------------------------------------------------------#
# demo test for example.com
#
# Test written by user 2005-10-18 +
# Purpose: Complete tests for the website.
# * steps..
# * steps..
#
#-------------------------------------------------------------#

# Includes
puts "--- includes: start ---"
require 'Watir' # the watir controller
include Watir
puts "--- includes: end ---"

# Declare Variables
root =	"http://example.com/"	# store
welcome =	root + "welcome"
store =	root + "store"
ordering =	root + "ordering"
locations =	root + "locations"
contact =	root + "contact"
$tests =	0
$warn =	0
$fail =	0
$pass =	0

# Methods
# Go directly to a url, with stdout reporting
def goto(url)
	$tests = $tests + 1
	puts " * test number: " + $tests.to_s
	begin
		puts "* going to: " + url
		$ie.goto(url)
	rescue
		puts ">>>ERROR: " + error_code_display()
		$fail = $fail + 1
	else
		puts "   ok, destination loads"
		$pass = $pass + 1
	end
	if $ie.url() == url
		puts "   ok, I stayed at the destination url"
	else
		puts "   warning: rewriting or redirection took effect"
		$warn = $warn + 1
	end
end

# Visit a specific link in the current page by specifying a url, with stdout reporting
def url(url)
	$tests = $tests + 1
	puts " * test number: " + $tests.to_s
	begin
		puts "* navigating to: " + url
		#$ie.goto(url)
		$ie.link(:url, url).click
	rescue
		puts ">>>ERROR: " + error_code_display()
		$fail = $fail + 1
	else
		puts "   ok, link exists and destination loads"
		$pass = $pass + 1
	end
	if $ie.url() == url
		puts "   ok, I stayed at the destination url"
	else
		puts "   warning: rewriting or redirection took effect"
		$warn = $warn + 1
	end
end

# Determine what kind of error message is on a page
def error_code_display()
	if $ie.contains_text("The page cannot be displayed")
		return "404"
	end
end
		#~ puts "   this page is not known"

# Search for text in a page
def search_text(string)
	$tests = $tests + 1
	puts " * test number: " + $tests.to_s
	puts "   searching the displayed page for: " + string
	if $ie.contains_text(string)
		puts "   ok -- found: " + string
		$pass = $pass + 1
	else
		puts ">>>FAIL -- could not find: " + string
		$fail = $fail + 1
	end
end

# Search for text in the HTML source of a page
class Watir::IE
	# $ie.contains_html( ) returns true/false
	def contains_html( input )
	html.scan( input ) != []
	end
end
def search_html(string)
	$tests = $tests + 1
	puts " * test number: " + $tests.to_s
	if $ie.contains_html(string)
		puts "   ok -- the HTML source has: " + string
		$pass = $pass + 1
	else
		puts ">>>FAIL -- the HTML source does NOT have: " + string
		$fail = $fail + 1
	end
end

# Check the current page's title against a string
def title(string)
	$tests = $tests + 1
	puts " * test number: " + $tests.to_s
	puts "   checking for the title: " + string
	if $ie.title() == string
		puts "   ok -- the title is: " + string
		$pass = $pass + 1
	else
		puts ">>>FAIL -- the title is NOT: " + string
		$fail = $fail + 1
	end
end


# #############################################
# The interesting stuff starts here.
# #############################################

puts "## Opening internet explorer"
#$ie = Watir::IE.new	# or I could # $ie = Watir::IE.start(root)
$ie = Watir::IE.start("about:blank")
# Make this one IE instance invisible (does not apply to popups):
#$ie.getIE.visible = false

puts "## Sanity-checking (fault-testing)"
goto("http://broken.example.com")
goto("http://broken.example.com")
url("http://broken.example.com")
search_text("doesnotexist")
search_html("doesnotexist")

# These generate failures and warnings, so subtract them from the score.
$tests = $tests - 5
$fail = $fail - 5
$warn = $warn - 3
puts "----\n\n"

puts "## Beginning the test"
puts "----\n\n"

=begin
puts "= Visit all main links ="
goto(root)
goto(welcome)
goto(store)
goto(ordering)
goto(locations)
goto(contact)
puts "----"

puts "= Ensure that all left_nav links are clickable from root ="
# or, I could #$ie.link(:text, "Pickaxe").click
goto(root)
url(welcome)
$ie.back;url(store)
$ie.back;url(ordering)
$ie.back;url(locations)
$ie.back;url(contact)
puts "----"

puts "= Ensure that all main links go to the proper title ="
goto(root)		;title("Store Name - Store")
goto(welcome)	;title("Store Name - Welcome")
goto(store)	;title("Store Name - Store")
goto(ordering)	;title("Store Name - Ordering")
goto(locations)	;title("Store Name - Locations")
goto(contact)	;title("Store Name - Contact")
puts "----"

puts "= Ensure that all main links go to the proper content ="
puts "* root should go to the store"
#goto(root)		;search_text("store")
goto(welcome)	;search_text("Dearest visitors, welcome")
#goto(store)	;search_text("store")
goto(ordering)	;search_text("Store Service")
goto(locations)	;search_text("Our Location")
goto(contact)	;search_text("Your message:")
puts "----"

puts "= Ensure that the pages which are loaded actually contain the right core ="
goto(root)		;search_html("/i/store.gif")
goto(welcome)	;search_html("/i/welcome.gif")
goto(store)	;search_html("/i/store.gif")
goto(ordering)	;search_html("i/ordering.gif")
goto(locations)	;search_html("i/locations.gif")
goto(contact)	;search_html("i/contact.gif")
puts "----"
=end

#~ goto("http://footarg.c")


puts "\n----"
puts "## End of test\n\n"
puts ""
puts "## Summary:"
puts "Tests: \t\t" +		$tests.to_s
puts "Passes: \t" +		$pass.to_s
puts "Fails: \t\t" +		$fail.to_s
puts ""
puts "(" + $warn.to_s + " warnings)"
puts ""


# Close the ie window
$ie.close()

# Wait for user input
puts "press <enter> to exit"
pause = gets

=begin
* Make separate methods for exact and inexact matches for text/html/title/whatever


Actions:

* [http://example.com/contact Send a message]
* Shopping:
** Browsing
** Picking
** Viewing the cart
** Checkout
** Associated documentation / disclaimers.


For irb:
load 'foo.rb'

Loadable scripts are given as examples on page 43 of 'scripting for testers'

Make a red/green thing.. which says if there are any failures.. or says if there is complete success.

# Download time:
Ie.goto('www.google.com')
Puts ie.down_load_time

A library which could expose the headers and other goodies:
http://raa.ruby-lang.org/project/http-access2/
=end
