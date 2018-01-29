def get_stuff(file)
  $exec = ""
  $name = ""
  File.open(file, 'r+').each { |line|
    # capture 'Exec' 
    #   Exec=xterm -name Terminal
    if line =~ /Exec=(.*)$/ then $exec = $1 end
    
    # capture 'Name'
    #   Name=XTerm
    if line =~ /Name=(.*)$/ then $name = $1 end
  }
end


# for all .desktop files in /usr/share/applications/
# $working = '/usr/share/applications/'
Dir.foreach('/tmp/') { |file|
  puts file
  next if File.extname(file) != ".desktop"
  # for some odd reason, no file is readable by the real user ID of this process.  Hmm.
#   next if File.readable?(file) != true

  # feed it the full pathname.
  file = File.join('/', 'tmp', file)

  # pick out the juicy bits
  get_stuff(file)
  # if there's something odd with this .desktop file, skip it.
  skip if $exec == nil or $name == nil

  puts $exec.inspect
  puts $name.inspect
}

fbpanel_menu = <<-FBPANEL_MENU
        menu {
            name = Testing
            image = /usr/share/fbpanel/images/redhat-internet.svg

            item {
                name = #{$name}
                image = /usr/share/pixmaps/gaimgnome-globe.svg
                action = #{$exec}
            }

        }
FBPANEL_MENU

puts fbpanel_menu
