# It works!
# TODO - fix links -- Rewrite `block matching 2.rb` into `block matching 3.rb` and re-use that code to easily split apart the `~/.fbpanel/default` file and insert the code.



# ---------------------
# Configuration
# ---------------------

# phase one
$dotdesktop_location        = '/usr/share/applications/'
$fbpanel_configuration_file = '/home/user/.fbpanel/default'

# phase two
$block_begin = '## flat.rb -- DO NOT CHANGE THIS LINE OR THE BLOCK OF CODE BELOW.'
$block_end   = '## flat.rb -- DO NOT CHANGE THIS LINE OR THE BLOCK OF CODE ABOVE.'


# ---------------------
# Phase one: Reading the .directory files.
# ---------------------

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
# It's ok to pick up this entire block and move it somewhere else in your config file though.
#
# See https://blog.spiralofhope.com/?p=34909
#
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
        name = #{i[1]}
        image = /usr/share/pixmaps/gaimgnome-globe.svg
        action = #{i[0]}
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


# ---------------------
# Phase two: putting it into the configuration file.
# ---------------------

@@output_top    = Array.new
@@output_middle = Array.new
@@output_bottom = Array.new

def split_file(file, block_begin, block_end)
#   puts file.inspect
  output_where = "top"
  File.open(file, 'r').each { |line|
    if line =~ /^#{block_begin}$/ then
      output_where = "middle"
    elsif line =~ /^#{block_end}$/ then
      output_where = "bottom"
      # am I the first match?
      # TODO: replace this with some kind of regex match-truth-detection thing.
      output_where2 = true
    end
    case output_where
      when "top" : @@output_top << line.chomp
      # Just throw away the middle:
      # when "middle" : @@output_middle << line.chomp
      when "bottom"
        # TODO: replace this with some kind of regex match-truth-detection thing.
        if output_where2 == true then
          # Just throw away the middle:
          @@output_middle << line.chomp
          output_where2 = false
        else
          @@output_bottom << line.chomp
        end
    end
  }
end

def build_new_file
  output = Array.new
  output << @@output_top
  output << $block_begin
  output << $fbpanel_menu
  output << $block_end
  output << @@output_bottom
  return output
end

def overwrite_file(file, output)
  File.open(file, 'w+') do |f| # open file for update
    output.each do |line|
      f.puts line
    end
  end
end


# ---------------------
# Do the work
# ---------------------

# phase one
dotdesktop_to_hash()
build_fbpanel_menu()
# puts $fbpanel_menu

# phase two
split_file($fbpanel_configuration_file, $block_begin, $block_end)
output = build_new_file
overwrite_file($fbpanel_configuration_file, output)
