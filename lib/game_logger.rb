require 'pp'
require 'pathname'
require 'active_support'
require 'active_record'
module GameLogger
  LOG_URL = '/game_logs/'
  
  
  require 'game_logger/parser'
  require 'game_logger/buffer'
  require 'game_logger/object_methods'
  require 'game_logger/middleware'
  
  class << self
    attr_accessor :path
    def path
      @path ||= defined?(RAILS_ROOT) ? Pathname.new(File.join(RAILS_ROOT, 'log/game_logs')) : nil
    end
    def gc
      gc_dir
    end
    
    def gc_dir(dir_path = GameLogger::LOG_PATH)
      if dir_path.directory?
        directory.each_entry do |path|
          gc_dir(path)
        end
      else
        if path.mtime < 1.day.ago || path.size > 300.kilobytes
          path.delete
        end
      end
    end
    
    def get_log(log_id)
      name = parse_log_id(log_id)
      path = GameLogger.path + name[:module] + name[:file]
      if File.exist?(path)
        GameLogger::Parser.parse(File.read(path))
      else
        nil
      end
    end
    
    def parse_log_id(log_id)
      p = log_id.match(/(.+)\.(.+)/i)
      {:module => p[1], :file => p[2] + '.log'}
    end
    
    def create_module(log_module)
      path = GameLogger.path + log_module
      unless path.exist?
        path.mkpath
      end      
    end
    
    def logger(logger_module, logger)
      Logger.new('logfile.log')
    end
    
    def buffer
      @buffer ||= Buffer.new
    end
    
    def enable(&block)      
      buffer.flush
      begin
        yield      
      rescue StandardError => e
        buffer.add :message => "Exception:", :objs => [e, e.backtrace]
      ensure
        buffer.write
      end      
    end
    
    def filter(controller, &block)
      enable(&block)
    end
  end
  
  def self.included(receiver)

    receiver.send :include, ObjectMethods
    receiver.extend ObjectMethods
  end
  

end