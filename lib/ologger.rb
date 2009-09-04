require 'pp'
require 'pathname'
require 'active_support'
require 'active_record'
module OLogger
  LOG_URL = '/game_logs/'
  
  
  require 'ologger/parser'
  require 'ologger/buffer'
  require 'ologger/object_methods'
  require 'ologger/middleware'
  
  class << self
    attr_accessor :path
    def path
      @path ||= defined?(RAILS_ROOT) ? Pathname.new(File.join(RAILS_ROOT, 'log/o_logs')) : nil
    end
    def gc
      gc_dir
    end
    
    def gc_dir(dir_path = OLogger.path)
      if dir_path.directory?
        dir_path.each_entry do |path|
          if not_self_and_parent path
            gc_dir(dir_path + path)
          end
        end
      else
        if needed_to_remove(dir_path)
          dir_path.delete
        end
      end
    end
    
    def not_self_and_parent(path)
      path.to_s != '.' && path.to_s != '..'
    end
    
    def needed_to_remove?(path)
      path.mtime < 1.day.ago || path.size > 300.kilobytes
    end
    
    def get_log(log_id)
      name = parse_log_id(log_id)
      path = OLogger.path + name[:module] + name[:file]
      if File.exist?(path)
        OLogger::Parser.parse(File.read(path))
      else
        nil
      end
    end
    
    def list_of_modules
      OLogger.path.entries.select {|v| not_self_and_parent v }
    end
    
    def get_logs(log_module)
      path = OLogger.path + log_module
      path.entries.select {|v| not_self_and_parent v }
    end
    
    def parse_log_id(log_id)
      p = log_id.match(/(.+)\.(.+)/i)
      {:module => p[1], :file => p[2] + '.log'}
    end
    
    def create_module(log_module)
      path = OLogger.path + log_module
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