#

# TODO
# For every file, create a still-working symlink to where it used to be.  Name it after the file, with '-dir'
#   I need to have a reference, just in case it's an unnamed file from a directory which has the artist/album names.


# Problem:
# Given a bunch of unsorted mp3s in multiple directories and subdirectories.
# I want to easily listen to 'x' of them, randomly chosen, and be able to find them easily and move them manually to where they belong in my hierarchy.


# - For x directories.
# -- Out of all files in all subdirectories.
# - Choose x files.
# - Create symbolic links to those files, in specific directory, renamed to (filename-ln).  They are not meant to be working symbolic links, just references to the original location.
# - Move the real files to that same specific directory.

# For x directories

seek_directories =  [
                      '/mnt/data/live/media/music/unsorted-tested',
                      '/mnt/data/live/media/music/unsorted-untested',
                    ]
#seek_directories = [ '/mnt/data/live/media/music/playlist-testing' ]
destination = '/mnt/data/live/media/music/playlist'
number_of_files = 3
player_launch = '/usr/bin/deadbeef'
player_command = [ '/usr/bin/deadbeef', '--queue' ]

=begin
seek_directories =  [
                      '/mnt/ssd/projects/ruby/git/ruby-random/rb/tests',
                      '/mnt/ssd/projects/ruby/git/ruby-random/rb/1',
                    ]
destination = '/mnt/ssd/projects/ruby/git/ruby-random/rb/d'
number_of_files = 3
player_launch = '/usr/bin/deadbeef'
player_command = [ '/usr/bin/deadbeef', '--queue' ]

# messy setup
system( 'rm', '-rf', destination )
system( 'mkdir',     destination )
system( 'mkdir', '-p', 'tests/a/b' )
files = [
  '1/file1',
  '1/file2',
  '1/file3',
  '1/file4',
  'tests/tests-1',
  'tests/tests-2',
  'tests/tests-3',
  'tests/tests-4',
  'tests/a/file-a',
  'tests/a/b/file-b',
]
# TODO:  I could implement a 'touch -p' which makes any missing directories.
files.each{ |f|
  system( 'touch', f )
}
=end


files = Array.new
# TODO:  Sanity-check if 'seek_directories' has valid directories in it.
seek_directories.each{ |dir|
  # '*/*' means all directories and subdirectories, ignoring dot files.
  files << Dir.glob( dir + '*/*' )
}

# TODO:  Sanity-check 'number_of_files'
files = files.flatten.shuffle[ 0..( number_of_files-1 ) ]

# I could do this without fileutils, but .. meh.
#   http://www.ruby-doc.org/core/classes/File.html
require 'fileutils'

# TODO:  Sanity-check 'destination'
# Create symbolic links.
# http://www.ruby-doc.org/stdlib/libdoc/fileutils/rdoc/classes/FileUtils.html#M000899
FileUtils::ln_s(
  files,
  destination,
  #options = { :force => true }
)

# Rename them all to filename-link
Dir.chdir( destination )
Dir.glob( '*' ).each{ |file|
  # Just in case.
  next if not File.symlink?( file )
  next if file[ -5..-1 ] == '-link'
  #http://www.ruby-doc.org/stdlib/libdoc/fileutils/rdoc/classes/FileUtils.html#M000908
  FileUtils::mv(
    file,
    file + '-link',
    #options = { :force => true }
  )
}

# Move the real files to that same specific directory.
FileUtils::mv(
  files,
  destination,
  #options = { :force => true }
)

#system( player_launch )

# TODO:  Ensure the player actually launches.  deadbeef has a habit of just dying on startup.

# This wasn't working.  I'd have to fart around a lot more to feed each item from files_string into system()
=begin
# Play them
files = Array.new
Dir.glob( destination + '/*' ).each{ |file|
  next if File.symlink?( file )
  files << file
}
files.shuffle!.flatten!

files_string = String.new
files.each{ |file|
  files_string << " '#{ file }'"
}
system( player_command, files_string )
=end

system( player_command, destination )
