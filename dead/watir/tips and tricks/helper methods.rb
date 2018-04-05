# Methods
# Go directly to a url, with stdout reporting
def goto(url)
	$tests = $tests + 1
	puts " --+ test number: " + $tests.to_s
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
	puts " --+ test number: " + $tests.to_s
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
	puts " --+ test number: " + $tests.to_s
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
	puts " --+ test number: " + $tests.to_s
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
	puts " --+ test number: " + $tests.to_s
	puts "   checking for the title: " + string
	if $ie.title() == string
		puts "   ok -- the title is: " + string
		$pass = $pass + 1
	else
		puts ">>>FAIL -- the title is NOT: " + string
		$fail = $fail + 1
	end
end
