module GameLogger
  module ObjectMethods
    def game_logger_module
      self.class.name.tableize
    end

    def game_logger_id
      if defined?(ActiveRecord::Base) && self.is_a?(ActiveRecord::Base)
        self.id
      else
        self.object_id
      end 
    end
    # g#group_fight.123#
    def game_logger(message, *objs)
      parsed_objs = objs.map { |o| game_logger_object_format(o) }
      GameLogger.buffer.add :message => message, :objs => parsed_objs, :logger_module => game_logger_module, :logger_id => game_logger_id
    end   
    def game_logger_object_format(obj)
      if defined?(ActiveRecord::Base) && obj.is_a?(ActiveRecord::Base)
        if obj == self
          obj.attributes
        elsif obj.game_logger_id
          GameLogger.buffer.add :message => 'Self:', :objs => [obj.attributes], :logger_module => obj.game_logger_module, :logger_id => obj.game_logger_id        
          "g##{obj.game_logger_module}.#{obj.game_logger_id}#"
        else
          obj
        end
      else
        obj
      end
    end  
  end  
end