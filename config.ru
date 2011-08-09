# 
# Set the local gem path
# works now
# 
ENV['GEM_HOME'] = '/home/evan_lecklider/.gems'
ENV['GEM_PATH'] = '$GEM_HOME:/usr/lib/ruby/gems/1.8'


# 
# Requires
# 
require 'rubygems'
# CRITICAL
# this clears the gem paths
# and reloads our custom gems
Gem.clear_paths
# now just require like normal
require 'sinatra'
# require 'pony'


# 
# Variables
# 
set     :env,     :production
disable :run

# 
# Fire it up
# 
# let's get it going :)
require 'app.rb'
# fire away
run Sinatra::Application
# done!