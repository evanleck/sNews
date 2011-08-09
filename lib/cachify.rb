# ===========
# = Cachify =
# ===========
module Sinatra
  module Cachify
    def recent
      recent = ""
    
      Dir.chdir("cache") do
        if Dir.glob("*").sort.last
          Dir.chdir( Dir.glob("*").sort.last ) do # jump into the most recent date folder
            if Dir.glob("*").sort.last
              recent = File.read( Dir.glob("*").sort.last ) # return the most recent file contents
            else
              recent = ''
            end
          end
        else
          recent = ''
        end
      end
    
      recent
    end
  
    def is_fresh?
      # is now is within 15 minutes of state return state    
      fresh     = false
      t         = Time.now
      folder    = t.strftime("%Y%m%d")
      file_name = t.strftime("%H%M")
      time_diff = 15
    
      if File.directory?("cache/#{folder}")
      
        Dir.chdir("cache/#{folder}") do
          last = Dir.glob("*").sort.last # returns some like "0357"
          max = (t+(60*time_diff)).strftime("%H%M") # 1 hour out
          min = (t-(60*time_diff)).strftime("%H%M") # 1 hour in the past
        
          if last
            if last < max && last > min # should be between
              fresh = true # we're up to date
            else
              fresh = false # nope, gotta do a new call
            end
          else
            fresh = false
          end
        end
      
      else
        fresh = false
      end
    
      fresh
    end
  
    def save_state( snapshot )
      t         = Time.now
      folder    = t.strftime("%Y%m%d")
      file_name = t.strftime("%H%M")
    
      unless File.directory?("cache/#{folder}")
        Dir.mkdir "cache/#{folder}"
      end

      File.open( "cache/#{folder}/#{file_name}", "w+") do |file|
        file.puts snapshot
      end
    end
  end
  
  helpers Cachify
end