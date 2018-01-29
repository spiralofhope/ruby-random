# --
# Problem
# --
# Given a bunch of unsorted mp3s in multiple directories and subdirectories.
# I want to easily listen to 'x' of them, randomly chosen, and be able to find them easily and move them manually to where they belong in my hierarchy.
# So..
# - For x directories.
# -- Out of all files in all subdirectories.
# - Choose x files.
# - Create symbolic links to those files, in specific directory, renamed to (filename-ln).  They are not meant to be working symbolic links, just references to the original location.
# - Move the real files to that same specific directory.

# For 'x' directories
array_of_directories_to_search_through =  [
                         '/l/_inbox/media-inbox/music/unsorted-tested/',
                         '/l/_inbox/media-inbox/music/unsorted-untested/',
                        ]
destination_directory = '/l/media/music/playlist/'
$sorted_directory     = '/l/media/music/sorted/'
# 'x' files
number_of_files = 3

def player_command_before( destination_directory )
  @pwd=Dir.pwd

  # I often leave a directory of the symlinks and directories, and just move the music away (to sort it).
  # When this happens, this script will notice that and (safely) remove old symlinks and directories before proceeding.
  if File.directory?( destination_directory ) then
    # Check if there are non-symlinks in it.  If no, delete it.
    flag = false
    dir = Dir.glob( File.join( destination_directory, '*' ) )
    dir.each { |f|
      flag = true if ( not File.symlink?( f ) ) and ( not File.directory?( f ) )
    }
    dir.each{ |f|
      File.delete( f ) if File.symlink?( f ) == true
      Dir.delete( f ) if File.directory?( f ) == true
    } if flag == false
  end

  # if it doesn't exist, make it
  Dir.mkdir( destination_directory ) if not File.directory?( destination_directory )
  
  dest = File.join( destination_directory, ' sorted' )
  File.symlink( $sorted_directory, dest ) if not File.symlink?( dest )

  # Run my file manager, with all kinds of settings so it can be coloured.
  # But do it in the proper directory.
  Dir.chdir( destination_directory )

  #system( "export LS_COLORS=\"no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=00;05;37;41:mi=00;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.rar=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.torrent=00;31:*.jpg=00;35:*~.jpg=00;33:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:*~.mp3=00;03:*~.ogg=00;03:*~.flv=00;03:*~.ape=00;03:*~.flv=00;03:*~.mpg=00;03:*~.wmv=00;03:*.part=00;03:\";ssfm &" )
  # TODO:  Feature request:  pcmanfm-mod appears to have no functionality to switch to a specific tab.  Opening the same tab twice.. opens it twice instead of switching to that tab like geany.
  system(
    "pcmanfm-mod \
      /l/media/music/sorted/ \
      #{destination_directory} \
      /l/_inbox/media-inbox/music \
      &"
    )

  Dir.chdir( @pwd )
end

def player_command_after( destination_directory )
  # TODO:  Ensure deadbeef actually launches.  It has a habit of just dying on startup.
  system( "/usr/bin/deadbeef #{ destination_directory } &" )
end

# --

# I could do this without fileutils, but .. meh.
#   http://www.ruby-doc.org/core/classes/File.html
require 'fileutils'

# --

def sanity_check(
                  array_of_directories_to_search_through,
                  destination_directory,
                  number_of_files
                )
  # TODO:  Flesh this functionality out.
  #
  # In case I've run this back-to-back, don't move any new files if there are already any in there.
  def files_exist?( destination_directory )
    # Returns true if the named file is a directory, or a symlink that points at a directory, and false otherwise.
    if File.directory?( destination_directory ) == false then
      puts "Aborting:  The destination directory does not exist:\n  #{ destination_directory }"
      return false
    end
    Dir.glob( destination_directory + '*' ).each{ |file|
      if not File.symlink?( file ) == true then
        puts "Aborting:  A non-symlink file already exists in:\n  #{ destination_directory }"
        return false
      end
    }
    return true
  end
  #
  return false if files_exist?( destination_directory ) == false
  return true
  #
end

def pick_files( array_of_directories, number_of_files )
  files = Array.new
  array_of_directories.each{ |dir|
    # '*/*' means all directories and subdirectories, ignoring dot files.
    files << Dir.glob( dir + '*/*' )
  }
  # TODO:  Sanity-check 'number_of_files'
  return files.flatten.shuffle[ 0..( number_of_files-1 ) ]
end

def create_source_symlinks( array_of_files, destination_directory )
  # For every file, create a still-working symlink to where it used to be.  Name it after the file, with '-dir'
  #   I need to have a reference, just in case it's an unnamed file from a directory which has the artist/album names.
  # Make symlinks to each file's original location.
  array_of_files.each{ |file|
    source = File.dirname(  file )
    # TODO?:  Also plant the last directory within the filename?
    dest   = File.basename( file ) + '-dir'
    dest   = File.join( destination_directory, dest )
    #puts source + "\n  => " + dest
    File.symlink( source, dest )
  }
end

def link_files( array_of_files, destination_directory )
  # TODO:  Sanity-check 'destination_directory'
  # Create symbolic links.
  # http://www.ruby-doc.org/stdlib/libdoc/fileutils/rdoc/classes/FileUtils.html#M000899
  FileUtils::ln_s(
    array_of_files,
    destination_directory,
    #options = { :force => true }
  )
  #
  # Rename them all to filename-link
  Dir.chdir( destination_directory )
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
end # link_files( array_of_files, destination_directory )

def move_files( array_of_files, destination_directory )
  # Move the real files to that same specific directory.
  FileUtils::mv(
    array_of_files,
    destination_directory,
    #options = { :force => true }
  )
end

# --

player_command_before( destination_directory )

Kernel::exit( status=false ) if sanity_check(
                                  array_of_directories_to_search_through,
                                  destination_directory,
                                  number_of_files
                                ) == false


array_of_files = pick_files( array_of_directories_to_search_through, number_of_files )

# For every file, create a still-working symlink to where it used to be.  Name it after the file, with '-dir'
create_source_symlinks( array_of_files, destination_directory )

# The files will be moved shortly, breaking these symlinks.  This is normal and expected.
link_files( array_of_files, destination_directory )

move_files( array_of_files, destination_directory )

player_command_after( destination_directory )
