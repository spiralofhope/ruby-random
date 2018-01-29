=begin
https://www.ruby-forum.com/topic/76062#121603
Kirk Haines says:


If it helps, I use the following bit of code when I need to
platform-independently start an external process within my test suites.
It depends on win32/process being available on Windows.

Usage is:  IWATestSupport.create_process(app_to_start)

i.e. IWATestSupport.create_process('webrick.rb')
=end



module IWATestSupport
   def self.create_process(args)
     @fork_ok = true unless @fork_ok == false
     pid = nil
     begin
       raise NotImplementedError unless @fork_ok
       unless pid = fork
         Dir.chdir args[:dir]
         exec(*args[:cmd])
       end
     rescue NotImplementedError
       @fork_ok = false
       begin
         require 'rubygems'
       rescue Exception
       end

       begin
         require 'win32/process'
       rescue LoadError
         raise "Please install win32-process to run all tests on a Win32 
platform.  'gem install win32-process' or 
http://rubyforge.org/projects/win32utils"
       end
       cwd = Dir.pwd
       Dir.chdir args[:dir]
       pid = Process.create(:app_name => args[:cmd].join(' '))
       Dir.chdir cwd
     end
     pid
   end
end
