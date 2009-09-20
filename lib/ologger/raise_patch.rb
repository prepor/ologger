module OLogger
  module Raiser
    def self.included(base)
      base.instance_methods.each do |m| 
        unless m =~ /^__|instance_eval|=|`/ 
          base.class_eval %Q{def with_ologger_#{m}(*args, &block)
            Thread.current[:ologger_raiser] = self
            without_ologger_#{m}(*args, &block)
          end
          }
          base.send :alias_method, :"without_ologger_#{m}", m
          base.send :alias_method, m, :"with_ologger_#{m}"
        end
      end
    end
  end
end

