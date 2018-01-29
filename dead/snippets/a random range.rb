#http://wayback.archive.org/web/20150921173208/http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/51207




def random(r)
 # assume r is a range of integers first < last
 echo r.first + rand(r.last - r.first + (r.exclude_end? ? 0 : 1))
end



# Usage
=begin
random(6 .. 10)
=> an integer from 6, 7, 8, 9, 10

random(6 ... 10)
=> an integer from 6, 7, 8, 9
=end


#How would I do this with a range of non-integers??
