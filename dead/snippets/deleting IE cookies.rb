#From the Watir mailing list:

=begin
Paul Rogers <paul.rogers at shaw.ca>
Nov 22, 2005 11:17 PM	 

[Wtr-general] Removing cookies	 

Here is the code to get rid of cookies. Sorry it took so long, had to
get permission, and then I kept forgetting

It was writtern on Win XP - the paths maybe different for win 2000

It may be possible to add a reg exp or string to limit the domain that
cookies are deleted

Thanks to Jason Scammell and Neteller for this.
=end

# file revision: "$Revision: #0 $"
# Author:: Jason Scammell jason.scammell at neteller.com
# Purpose:  To delete all cookies on the PC
# Date: Oct 24, 2005
class Dir
   require 'find'
   include Find
   def Dir.visit(dir = '.', files_first = false, &block)
       if files_first
           paths = []
           Find.find(dir) { |path| paths << path }
           paths.reverse_each {|path| yield path}
       else
           Find.find(dir, &block)
       end
   end
   # simulates unix rm -rf command
   def Dir.rm_rf(dir)

       Dir.visit(dir, true) do |path|
           if FileTest.directory?(path)
               begin
                   Dir.unlink(path)
               rescue # Security Exception for Content.IE
               end
           else
               puts "removing #{ path }"
               begin
                   File.unlink(path)
               rescue => e #Security exception index.dat etc.
                   puts "Exception " + e
               end
           end
       end
   end
end

class CookieKiller
   def self.kill()
       dir =CookieKiller.cookie_dir()
       Dir.rm_rf( dir)
   end
   def self.cookie_dir()
       return ENV['HOMEDRIVE'] + '\\' + ENV['HOMEPATH'] + "\\Cookies"
   end

end



# file revision: "$Revision: #0 $"
# Author:: Jason Scammell jason.scammell at neteller.com
# Purpose:  To test the CookieKiller class
# Date: Oct 24, 2005

require '../neteller.rb'
require 'test/unit'
class CookieKillerTest < Test::Unit::TestCase

   def test_cookie_killer_dir()

      cookie_count = get_file_count()
       puts cookie_count -3 # files .,..,index.dat are never deleted.
       CookieKiller.kill()
       delete_count= get_file_count()
       puts delete_count
       assert (get_file_count() ==3)

   end

   def get_file_count()
       dir = CookieKiller.cookie_dir()
       d = Dir.new(dir)
       count=0
       d.each  do |x|
           count = count +1
       end
       return count
   end

end
