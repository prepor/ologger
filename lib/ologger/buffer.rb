module OLogger
  class Buffer
    attr_accessor :messages
  
    def initialize
      self.messages = []
    end
  
    def flush
      self.messages = []
    end
  
    def add(options = {})
      messages << options
    end
  
    def grouped_messages
      messages.group_by { |b| "#{b[:logger_module]}.#{b[:logger_id]}"}
    end
  
    def write
      grouped_messages.each do |k, game_module_messages|
        logger_module = game_module_messages.first[:logger_module] || 'unknown'
        logger_id = game_module_messages.first[:logger_id] || 'unknown'
        OLogger.create_module(logger_module)        
        (OLogger.path + logger_module + (logger_id.to_s + '.log')).open('a+') do |file|
          game_module_messages.each do |message|
            file.puts "#{Time.now.strftime('%d.%m.%Y %H:%M:%S')}: #{message[:message]}"
            message[:objs].each { |obj| PP.pp(obj, file) } if message[:objs]
          end
        end        
      end 
    end
  
  end
end