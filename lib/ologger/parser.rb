module OLogger
  module Parser    
    def self.parse(str)
      str.gsub(/g#([\d\w.]+)#/i, "<a href=\"#{OLogger::LOG_URL}\\1\">\\1</a>")
    end
  end
  
end
  