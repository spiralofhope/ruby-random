# Success with reading groups of files
# Using a hash nicely
# Outputting nicely
# Using the proper location now (I guess `File.open` with `r+` was wrong..)



# Configuration
$working = '/usr/share/applications/'


# Initialization
$h = Hash.new


def get_stuff(dir, file)
  file = File.join(dir, file)
#   puts "working on:  " + file.inspect
  File.open(file, 'r').each { |line|
    # capture 'Exec' 
    #   Exec=xterm -name Terminal
    if line =~ /Exec=(.*)$/ then @one=$1 end
    
    # capture 'Name'
    #   Name=XTerm
    if line =~ /Name=(.*)$/ then @two=$1 end
  }
#   puts @one.inspect
#   puts @two.inspect
  if @one != nil && @two != nil then $h[@one] = @two end
end



# for all .desktop files in $working
Dir.foreach($working) { |file|
#   puts file.inspect
  next if File.extname(file) != ".desktop"
  # for some odd reason, no file is readable by the real user ID of this process.  Hmm.
#   next if File.readable?(file) != true

  # pick out the juicy bits
  get_stuff($working, file)
}

# puts $h.inspect

# the beginning of the menu
fbpanel_menu = <<-FBPANEL_MENU
Plugin {
  type = menu
  config {
    image = /usr/share/fbpanel/images/gnome-globe.svg
    menu {
      name = Testing
      image = /usr/share/fbpanel/images/redhat-internet.svg
FBPANEL_MENU

# building the items in the menu
$h.each { |i|
# puts i.inspect
fbpanel_menu = fbpanel_menu + <<-FBPANEL_MENU
      item {
        name = #{i[0]}
        image = /usr/share/pixmaps/gaimgnome-globe.svg
        action = #{i[1]}
      }
FBPANEL_MENU
}

# closing the menu
fbpanel_menu = fbpanel_menu + <<-FBPANEL_MENU
    }
  }
}
FBPANEL_MENU

puts fbpanel_menu
