=begin
Why it's stupid to `use a variable as a variable name'
  http://perl.plover.com/varvarname.html

A More Direct Explanation of the Problem
  http://perl.plover.com/varvarname2.html

What if I'm Really Careful?
  http://perl.plover.com/varvarname3.html
=end


@ab = "pass"
puts instance_variable_get("@#{"a" + "b"}")

$variable = 123
puts "#{eval('$' + 'var' + 'iable')}"
$a = true
puts "#{eval('$' + 'var' + (if $a == true then "iable" end))}"
puts eval('$' + 'var' + ($a ? "iable" : ""))

@some_map['var'] = "pass"
def test(string)
 puts @some_map[string]
end

item = "test"
$test_items = "hey"
if eval('$' + item + '_items') != nil then puts "ok" end

#   write "buy 10 #{instance_variable_get("@#{item + "_item"}")}"
#   write "put all.#{instance_variable_get("@#{item + "_item"}")} #{$bag}"
  write "buy 10 #{eval('$' + item + '_items')}"
  write "put all.#{eval('$' + item + '_items')} #{$bag}"

    eval('$' + item + '_items' + ' += 10')
    _item_report(item, eval('$' + item + '_items'))
    _item_report(item, eval('$' + item + '_items' + ' += 10'))
