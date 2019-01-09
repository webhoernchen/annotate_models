# == Annotate Routes
# 
# Based on:
# 
# 
#
# Prepends the output of "rake routes" to the top of your routes.rb file.
# Yes, it's simple but I'm thick and often need a reminder of what my routes mean.
# 
# Running this task will replace any exising route comment generated by the task.
# Best to back up your routes file before running:
# 
# Author:
#  Gavin Montague
#  gavin@leftbrained.co.uk
#   
# Released under the same license as Ruby. No Support. No Warranty.module AnnotateRoutes
#
module AnnotateRoutes 
  PREFIX = "#== Route Map"
  
  def self.do_annotate 
    routes_rb = File.join('config', 'routes.rb')
    generated_routes = "#{routes_rb}.txt"
    header = PREFIX + "\n# Generated on #{Time.now.strftime("%d %b %Y %H:%M")}\n#"
    if File.exists? routes_rb
      routes_map = `rake routes`
      routes_map = routes_map.split("\n")
      routes_map.shift # remove the first line of rake routes which is just a file path
      routes_map = routes_map.inject(header){|sum, line| sum << "\n# " << line }
      content = File.read routes_rb
      content, old = content.split(/^#== Route .*?\n/)

      File.open(routes_rb, 'w') do |f| 
        f.puts content.sub!(/\n?\z/, "\n")
      end

      File.open(generated_routes, 'w') do |f| 
        f.write routes_map
      end

      puts "Route file annotated."
    else
      puts "Can`t find routes.rb"
    end
  end

end
