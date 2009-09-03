module GameLogger
  module Parser    
    def self.parse(str)
      str.gsub(/g#([\d\w.]+)#/i, "<a href=\"#{GameLogger::LOG_URL}\\1\">\\1</a>")
    end
  end
  
end
  