# Close the ie window:
ie.close()


# Wait for user input:
puts "press <enter> to exit"
pause = gets


# Make this one IE instance invisible (does not apply to popups):
$ie.getIE.visible = false


# Displaying the type of error:
#   - To determine the type of error (404, etc).. simply search the page for the appropriate text.
#   - Other, more universal, methods are being researched.
