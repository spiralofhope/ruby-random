# Moved everything into their own spaces
# Quick tidyup



# Configuration
$dotdesktop_location        = '/usr/share/applications/'
$fbpanel_configuration_file = '~/.fbpanel/default'


# Initialization
$menu_hash = Hash.new


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
  if @one != nil && @two != nil then $menu_hash[@one] = @two end
end


# absorb $dotdesktop_location/*.desktop into $menu_hash
def dotdesktop_to_hash
  # for all .desktop files in $dotdesktop_location
  Dir.foreach($dotdesktop_location) { |file|
  #   puts file.inspect
    next if File.extname(file) != ".desktop"
    # for some odd reason, no file is readable by the real user ID of this process.  Hmm.
  #   next if File.readable?(file) != true
  
    # pick out the juicy bits
    get_stuff($dotdesktop_location, file)
  }
end

# TODO: ungh, this block can't be tabbed out properly because of the 'here document'.
def build_fbpanel_menu
# the beginning of the menu
$fbpanel_menu = <<-FBPANEL_MENU
Plugin {
  type = menu
  config {
    image = /usr/share/fbpanel/images/gnome-globe.svg
    menu {
      name = Testing
      image = /usr/share/fbpanel/images/redhat-internet.svg
FBPANEL_MENU

# building the items in the menu
$menu_hash.each { |i|
# puts i.inspect
$fbpanel_menu = $fbpanel_menu + <<-FBPANEL_MENU
      item {
        name = #{i[0]}
        image = /usr/share/pixmaps/gaimgnome-globe.svg
        action = #{i[1]}
      }
FBPANEL_MENU
}

# closing the menu
$fbpanel_menu = $fbpanel_menu + <<-FBPANEL_MENU
    }
  }
}
FBPANEL_MENU
end


# Do the work
dotdesktop_to_hash()
build_fbpanel_menu()
puts $fbpanel_menu


# Ok, now I have one big menu file.  Let's search/replace the menu in ~/.fbpanel/default
# Search through $fbpanel_configuration_file for my code, and
#   delete the following menu file.
#   insert fbpanel_menu
