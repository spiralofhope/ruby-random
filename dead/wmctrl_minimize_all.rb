#!/usr/bin/env ruby
# The above line must be the first line in the project.

# Using wmctrl to minimize all applications
#   http://blog.spiralofhope.com/?p=24633


# ----
# configuration
# ----

Ruby_version_required = '1.8.5'
Common_libs_directory = '/home/user/working/rb/programming/libraries/'
# used for 'vputs' for the chattier 'puts' statements.
# also can be set at the commandline or an environment variable, I think.
$VERBOSE = false


# ----
# common stuff
# ----

Pwd = Dir.pwd
require File.join(Common_libs_directory, 'boilerplate_libs.rb')
Dir.chdir(Pwd)

# include this application's and its lib directorires into the path for 'require'
# TODO: This is nice, and should be reworked so that it's re-usable in its own method.
if File.symlink?($0)
  # $LOAD_PATH aka $: - p 335
  $LOAD_PATH << File.dirname(File.readlink($0))
  $LOAD_PATH << File.join(File.dirname(File.readlink($0)), "lib")
else
  $LOAD_PATH << File.dirname(File.expand_path($0))
  $LOAD_PATH << File.join(File.dirname(File.expand_path($0)), "lib")
end
# FIXME: I don't remember what this is for.  Something about running the script at the commandline.
# But the /../lib doesn't seem right.
# $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib") if __FILE__ == $0


# ----
# Begin your program here...
# ----

# discover what desktop is current
def current_desktop()
  desktop = exec_and_return_output_array('wmctrl -d')
  desktop.each { |i|
    if i.split[1] == '*' then return i.split[0].to_i end
  #   if desktop[i].split[1] == '*' then puts i end
  }
end

# discover the list of all applications
def all_applications()
  applications = exec_and_return_output_array('wmctrl -l')
end

# figure out the list of applications on the current desktop
def all_applications_by_desktop(desktop)
  desktop_applications = Array.new
  all_applications = all_applications()
  all_applications.each { |i|
    if i.split[1].to_i == desktop then desktop_applications << i end
  }
  return desktop_applications
end

def all_applications_desktop_action(command, desktop)
  output = Array.new
  all_applications_by_desktop(desktop).each { |i|
    output << exec_and_return_output_array("wmctrl -i -r #{i.split[0]} -b #{command}")
  }
  return output
end

all_applications_desktop_action('toggle,shaded', current_desktop())
# Also minimize applications which are sticky...
all_applications_desktop_action('toggle,shaded', -1)

# learn which applications are not minimized
# minimize all non-minimized applications
# set some variable to true 

__END__

Also do the reverse:

    * if some variable is true
    * use wmctrl get a list of all applications
    * learn which applications are on the current desktop
    * learn which applications are minimized
    * restore all minimized applications
    * set some variable to false
