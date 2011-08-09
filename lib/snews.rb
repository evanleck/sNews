module Sinatra
  module Snews
    # report hotness back
    def spicyness( amI )
      hotness = ""
      hotness = "spicy"     unless (amI/".c2").empty?
      hotness = "onfire"    unless (amI/".c3").empty?
      hotness = "volcanic"  unless (amI/".c4").empty?
      hotness
    end

    def check
      # check freshness
      if is_fresh? # fresh
        ret = recent
      else # not fresh
        ret = load
      end
    
      ret
    end

    def load
      tlist    = Hpricot( open( "http://www.google.com/trends/hottrends" ) )
      hotlinks = (tlist/".hotColumn a")
      ret      = "<div id='frag'><ol>"
        
      # loop it out
      hotlinks.each do |l|
        href     = l['href']
        name     = l.inner_text
        # grab the page for the term
        linkDoc  = Hpricot( open( "http://www.google.com"+href ) )
        # grab the hot scale
        hot_scale = (linkDoc/".hotScale")
        # record the hotness as a string
        hotness  = spicyness( hot_scale )

        ret << "<li><div class='tehot'><h1><span class='name #{hotness}'><a href='http://www.google.com#{href}'>#{name}</a></span></h1><div class='desc'>" + (linkDoc/".gs-result").inner_html + "</div></div></li>"
      end
    
      ret << "</ol></div>"
    end
    
    def recent
      lrecent = ''
      
      Dir.chdir("cache") do
        Dir.chdir( Dir.glob("*").sort.last ) do # jump into the most recent date folder
          # return the most recent file contents
          lrecent = File.read( Dir.glob("*").sort.last ) if Dir.glob("*").sort.last
        end if Dir.glob("*").sort.last
      end
    
      lrecent
    end
  
    def is_fresh?
      # is now is within 15 minutes of state return state    
      fresh     = false
      t         = Time.now
      folder    = t.strftime("%Y%m%d")
      file_name = t.strftime("%H%M")
      time_diff = 15
      
      return catch(:fresh) {
        Dir.chdir("cache/#{folder}") do
          throw(:fresh, false) unless last = Dir.glob("*").sort.last # returns some like "0357"
          max  = (t+(60*time_diff)).strftime("%H%M")
          min  = (t-(60*time_diff)).strftime("%H%M")
          
          throw(:fresh, true) if last < max && last > min
        end if File.directory?("cache/#{folder}")
        
        throw(:fresh, false)
      }
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
  
  helpers Snews
end