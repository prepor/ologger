class StandardError
  attr_accessor :obj
end
module Kernel
  def ologger_raise(*argv)
    if Thread.current[:ologger_raiser]
      argv.each do |e|
        e.obj = self if e.is_a?(StandardError)
      end
      ologger_old_raise(*argv)
    else
      ologger_old_raise(*argv)
    end
  end

  alias_method :ologger_old_raise, :raise
  alias_method :raise, :ologger_raise

end

