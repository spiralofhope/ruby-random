=begin
http://wayback.archive.org/web/20090201142459/http://hacks.atrus.org/ruby/method_finder.rb


See also
  http://wayback.archive.org/web/20090227061933/http://redhanded.hobix.com/inspect/stickItInYourIrbrcMethodfinder.html

Dr Nic
  http://wayback.archive.org/web/20061029212743/http://drnicwilliams.com/2006/10/12/my-irbrc-for-consoleirb/
.. gemified the version by Nikolas Coukouma.  I think it's the below version.  To install that gem, do:

 gem install what_methods

=end

# Some credits:
# Code this verions is based on: Andrew Birkett
#   http://www.nobugs.org/developer/ruby/method_finder.html
# Improvements from _why's blog entry
# * what? == - _why
# * @@blacklist - llasram
# * $stdout redirect - _why
#   http://redhanded.hobix.com/inspect/stickItInYourIrbrcMethodfinder.html
# Improvements from Nikolas Coukouma
# * Varargs and block support
# * Improved catching
# * Redirecting $stdout and $stderr (independently of _why)
#   http://atrustheotaku.livejournal.com/339449.html
# Improvement from Anthony Bailey
# * Prevent breaking when reloaded
#   http://nikolasco.livejournal.com/339449.html?thread=789241
#
# A version posted in 2002 by Steven Grady:
#   http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/32844
# David Tran's versions:
# * Simple
#   http://www.doublegifts.com/pub/ruby/methodfinder.rb.html
# * Checks permutations of arguments
#   http://www.doublegifts.com/pub/ruby/methodfinder2.rb.html
#
# Last updated: 2007/01/04

class Object
  def what?(*a)
    MethodFinder.new(self, *a)
  end
  def _clone_
    self.clone
  rescue TypeError
    self
  end
end

class DummyOut
  def write(*args)
  end
end

class MethodFinder
  @@blacklist = %w(daemonize display exec exit! fork sleep system syscall what?)
  
  def initialize( obj, *args )
    @obj = obj
    @args = args
  end
  def ==( val )
    MethodFinder.show( @obj, val, *@args )
  end
  
  # Find all methods on [anObject] which, when called with [args] return [expectedResult]
  def self.find( anObject, expectedResult, *args, &block )
    stdout, stderr = $stdout, $stderr
    $stdout = $stderr = DummyOut.new
    # change this back to == if you become worried about speed and warnings.
    res = anObject.methods.
          select { |name| anObject.method(name).arity <= args.size }.
          select { |name| not @@blacklist.include? name }.
          select { |name| begin 
                   anObject._clone_.method( name ).call( *args, &block ) == expectedResult; 
                   rescue Object; end }
    $stdout, $stderr = stdout, stderr
    res
  end
  
  # Pretty-prints the results of the previous method
  def self.show( anObject, expectedResult, *args, &block)
    find( anObject, expectedResult, *args, &block).each { |name|
      print "#{anObject.inspect}.#{name}" 
      print "(" + args.map { |o| o.inspect }.join(", ") + ")" unless args.empty?
      puts " == #{expectedResult.inspect}" 
    }
  end
end
