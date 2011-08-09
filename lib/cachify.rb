require 'ftools'
require 'pathname'
# ===========
# = Cachify =
# ===========
class Cachify
=begin  

  TODO Save current state to file and load if still valid
  if not valid
    render last valid & notice "loading latest"
    load latest
    render latest
  else
    render valid cache file
  end
  
=end
  
  def self.recent
    recent = ""
    
    Dir.chdir("cache") do
      Dir.chdir( Dir.glob("*").sort.last ) do # jump into the most recent date folder
        recent = File.read( Dir.glob("*").sort.last ) # return the most recent file contents
      end
    end
    
    recent
  end
  
  def self.is_fresh
    # is now is within 15 minutes of state return state
    
    fresh = false
    t = Time.now
    folder = t.strftime("%Y%m%d")
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
  
  def self.save_state( snapshot )
    t = Time.now
    folder = t.strftime("%Y%m%d")
    file_name = t.strftime("%H%M")
    
    unless File.directory?("cache/#{folder}")
      File.makedirs "cache/#{folder}"
    end

    File.open( Pathname.new( "cache/#{folder}/#{file_name}" ), "w+") do |file|
      file.puts snapshot
    end
    
  end

=begin  
  def self.load_state( snapshot )
    begin
      File.read( snapshot )
    rescue Exception => e
      # log it
      # no cache so load it fresh
    end
    # return state info or nothing
  end
=end
end