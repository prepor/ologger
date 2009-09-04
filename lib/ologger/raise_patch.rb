class StandardError
  attr_accessor :obj
end
module Kernel
  def ologger_raise(*argv)
    if Thread.current[:ologger_raiser]
      ex = StandardError.new(*argv)
      ex.obj = self
      ologger_old_raise ex
    else
      ologger_old_raise(*argv)
    end
  end

  alias_method :ologger_old_raise, :raise
  alias_method :raise, :ologger_raise

end