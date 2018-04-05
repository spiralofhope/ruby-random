# method to wait until window dissapears
#
# Parameters:
# hwnd - window handle
#
# Returns: elapsed time in seconds
#



=begin
Miroslav Rajcic <rajcic at sokrates.hr>
date		Dec 14, 2005 3:25 AM	 
subject		[Wtr-general] Code donation :)	 

I thought to donate some code to the Watir project, in case the code is
found useful.

I needed method to wait for file download window to terminate (so I could
chack if the local file has correct size), and the resulting code is found
below.

Regards,
 Miroslav
=end


def waitUntilWindowGone(hwnd)

puts "Preparing to wait until window terminates, hwnd=" + hwnd.to_s

time_start = Time::now().to_i # start time (integer in seconds since
epoch)

# wait until window dissapears
is_window = Win32API.new('user32','IsWindow','L','I')
is_alive = is_window.call(hwnd)
while is_alive > 0
  sleep 0.1
  is_alive = is_window.call(hwnd)
end

time_end = Time::now().to_i # end time
span_sec = time_end - time_start

#puts "Window terminated, elapsed time=" + span_sec.to_s

return span_sec
end
