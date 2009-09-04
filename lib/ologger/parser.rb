module OLogger
  module Parser    
    def self.parse(str)
      str.gsub(/g#([\d\w.]+)\.([\d\w.]+)#/i, "<a href=\"#{OLogger::LOG_URL}\\1/\\2\">\\1/\\2</a>")
    end
  end
  
end
  