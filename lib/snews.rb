module Snews  
  
  # report hotness back
  def howHot( amI )
    hotness = ""
    hotness = "spicy"     unless (amI/".c2").empty?
    hotness = "onfire"    unless (amI/".c3").empty?
    hotness = "volcanic"  unless (amI/".c4").empty?
    hotness
  end

  def checkHotness
    # check against Cachify
    if is_fresh? # fresh
      ret = recent
    else # not fresh
      ret = loadHotness
    end
    
    ret
  end

  def loadHotness
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
      hotScale = (linkDoc/".hotScale")
      # record the hotness as a string
      hotness  = self.howHot( hotScale )

      ret << "<li><div class='tehot'><h1><span class='name #{hotness}'><a href='http://www.google.com#{href}'>#{name}</a></span></h1><div class='desc'>" + (linkDoc/".gs-result").inner_html + "</div></div></li>"
    end
    
    ret << "</ol></div>"
  end
  
  def get_snews
    checkHotness
  end
end
