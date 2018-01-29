#!/usr/local/bin/ruby -w

#http://wayback.archive.org/web/20071012191658/http://blog.zenspider.com/archives/2006/08/new_and_improve.html


require 'rdoc/ri/ri_paths'
require 'find'
require 'yaml'

search = ARGV.shift

puts "Searching for #{search}"
puts

dirs = RI::Paths::PATH
dirs.each do |dir|
  Dir.chdir dir do
    Find.find('.') do |path|
      next unless test ?f, path
      yaml = File.read path
      if yaml =~ /#{search}/io then
        full_name = $1 if yaml[/full_name: (.*)/]
        puts "** FOUND IN: #{full_name}"
        
        data = YAML.load yaml.gsub(/ \!.*/, '')
        desc = data['comment'].map { |x| x.values }.flatten.join("\n").gsub(/&quot;/, "'").gsub(/&lt;/, "<").gsub(/&gt;/, ">").gsub(/&amp;/, "&")
        puts
        puts desc
        puts
      end
    end
  end
end
