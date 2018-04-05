# Test the helper methods with guaranteed failures.


puts "## Opening internet explorer"
$ie = Watir::IE.new	# or I could # $ie = Watir::ie.start(root)

puts "## Sanity-checking (fault-testing)"
goto("http://idonotexistreallyidontexist.com")
goto("http://idonotexistreallyidontexist.com")
url("http://idonotexistreallyidontexist.com")
search_text("idonotexistreallyidonotexist")
search_html("idonotexistreallyidonotexist")

# These generate failures and warnings, so subtract them from the score.
$tests = $tests - 5
$fail = $fail - 5
$warn = $warn - 3
puts "----\n\n"
