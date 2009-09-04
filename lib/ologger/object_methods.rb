module OLogger
  module ObjectMethods
    def ologger_module
      self.class.name.tableize
    end

    def ologger_id
      if defined?(ActiveRecord::Base) && self.is_a?(ActiveRecord::Base)
        self.id
      else
        self.object_id
      end 
    end
    # g#group_fight.123#
    def ologger(message, *objs)
      parsed_objs = objs.map { |o| ologger_object_format(o) }
      OLogger.buffer.add :message => message, :objs => parsed_objs, :logger_module => ologger_module, :logger_id => ologger_id
    end   
    def ologger_object_format(obj)
      if defined?(ActiveRecord::Base) && obj.is_a?(ActiveRecord::Base)
        if obj == self
          obj.attributes
        elsif obj.ologger_id
          OLogger.buffer.add :message => 'Self:', :objs => [obj.attributes], :logger_module => obj.ologger_module, :logger_id => obj.ologger_id        
          "g##{obj.ologger_module}.#{obj.ologger_id}#"
        else
          obj
        end
      else
        obj
      end
    end  
  end  
end