# Within the helper methods, I could just to a bunch of stuff like this:

$tests = $tests + 1
$fail = $fail + 1


# Output of a score
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
