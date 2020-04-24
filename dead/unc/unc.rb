#!/usr/bin/env ruby



Ruby_version_required = '1.8.5'
Common_libs_directory = '/home/user/ruby/libraries/'
# Used for 'vputs' for the chattier 'puts' statements.
#   Also can be set at the commandline or an environment variable, I think.
$VERBOSE = false



Pwd = Dir.pwd
require File.join(Common_libs_directory, 'boilerplate_libs.rb')
Dir.chdir(Pwd)

# Include this application's and its lib directorires into the path for 'require'
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



# TODO: This is totally broken because it's wrapped in bash.  =(
def help
# FIXME clear the screen
help = <<ENDTEXT
== Usage

   ruby #{$0} [file]

== Examples

   ruby #{$0} [file]
     => make a directory
     => uncompresses the files into that directory
ENDTEXT
print help
end



# create_sample_desc(Desc_file)

# but this won't really work anymore...
if ARGV[0] == nil then help ; exit end


# If the parameter is a directory, then abort -- TODO: uncompress all appropriate files?
# If the parameter is not a file, then abort
# If the file does not exist, then abort


# Act on a particular extension:
# TODO: This is totally broken because it's wrapped in bash.  Output is not displayed.
def tar_gz(filename, basename)
  # TODO: detect if there's an appropriately-named subdirectory within.  If not, then make/cd into it.
  exec_and_return_output_array("tar -xvvzf #{filename}")
  puts basename
  # puts 'filename - without extension'
end


def unc_common(command, filename, basename)
  Dir.mkdir(basename)
  Dir.chdir(basename)
  exec_and_return_output_array("#{command + File.join('..',filename)}")
  puts basename
end


# Discover the extension or combination-extension and act on it:
def act_on_file(filename)
  basename = string_basename(filename)
  case File.extname(filename)
    when ".gz"
      # .tar.gz
      if File.extname(string_basename(filename)) == ".tar" then tar_gz(filename, basename) end
    # This is the shortform for .tar.gz
    when ".tgz" : tar_gz(filename, basename)
    # TODO: This can't deal with passwords.
    when ".rar" : unc_common("unrar x ", filename, basename)
  end
end



act_on_file(ARGV[0])
