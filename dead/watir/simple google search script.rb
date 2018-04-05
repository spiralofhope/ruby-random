#   https://web.archive.org/web/20050208142208/http://wtr.rubyforge.org/example_testcase.html
# I believe the "Jonathan Kohl" who is referenced is http://www.kohl.ca/


#---


# Section 1: Comments
#-------------------------------------------------------------#
# demo test for the WATIR controller
#
# Simple Google test written by Jonathan Kohl 10/10/04
# Purpose: to demonstrate the following WATIR functionality:
# * entering text into a text field
# * clicking a button
# * checking to see if a page contains text.
# Test will search Google for the "pickaxe" Ruby book
#
#-------------------------------------------------------------#

# Section 2: Includes
require 'Watir' # the watir controller
include Watir

# Section 3: Declare Variables
test_site = 'http://www.google.com' 

# Section 4: Open an Internet Explorer Browser
puts "## Opening ie"
ie = IE.new

# Section 5: Interacting With Google
# Beginning the test case
puts "## Beginning of test: google search\n\n"

# Step 1: Go to the Google site
puts "Step 1: go to the test site: " + test_site
ie.goto(test_site)
puts    "Action: entered " + test_site + "in the address bar.\n\n"

# Step 2: Enter Search Term "pickaxe" in the search field
puts "Step 2: enter 'pickaxe' in the search text field\n\n"
ie.text_field(:name, "q").set("pickaxe") # q is the name of the search field
puts    " Action: entered pickaxe in the search field\n\n"

# Step 3: Click the "Google Search" button
puts "Step 3: click the 'Google Search' button\n\n"
ie.button(:name, "btnG").click # "btnG" is the name of the button
puts    " Action: clicked the Google Search button.\n\n"

# Section 6: Evaluating the Results
# The Expected Result
puts "Expected Result: "
puts " - a Google page with results should be shown.\n'Programming Ruby' should be high on the list.\n\n"

# Verify Results
puts "Actual Result: Check that the 'Programming Ruby' link\nappears on the search results page\n\n"
if ie.contains_text("Programming Ruby")
   puts "Test Passed. Found the test string: Programming Ruby.\n Actual Results match Expected Results."
else
   puts "Test Failed! Could not find: Programming Ruby"
end
puts ""

# End of Test Case
puts '##End of test: Google search\n\n'
puts # -end of simple Google search test

# Close the ie window
ie.close()

# Wait for user input
puts "press <enter> to exit"
pause = gets
