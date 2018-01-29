# From a textfile, make three arrays. One is above the matching block, one is the matching block, and one is below the matching block

$block_begin = '## begin block'
$block_end   = '## end block'
$test_file = '/tmp/some_file.tmp'

def create_sample_file(file)
file_contents = <<ENDTEXT
some text a
some more text a
## begin block
some text b
some more text b
## end block
some text c
some more text c
ENDTEXT
  #Insert Desc_file_contents
  File.open(file, 'w+') do |f| # open file for update
    f.print file_contents      # write out the example description
  end                          # file is automatically closed
end

@@output_top    = Array.new
@@output_middle = Array.new
@@output_bottom = Array.new

def get_it(file)
#   puts file.inspect
  output_where = "top"
  File.open(file, 'r').each { |line|
    if line =~ /^#{$block_begin}$/ then
      output_where = "middle"
    elsif line =~ /^#{$block_end}$/ then
      output_where = "bottom"
      # am I the first match?
      # TODO: replace this with some kind of regex match-truth-detection thing.
      output_where2 = true
    end
    case output_where
      when "top"    : @@output_top    << line.chomp
      when "middle" : @@output_middle << line.chomp
      when "bottom"
        # TODO: replace this with some kind of regex match-truth-detection thing.
        if output_where2 == true then
          @@output_middle << line.chomp
          output_where2 = false
        else
          @@output_bottom << line.chomp
        end
    end
  }
end

create_sample_file($test_file)
get_it($test_file)
puts @@output_top
puts "----------"
puts @@output_middle
puts "----------"
puts @@output_bottom
