require 'rubygems'
require 'test/unit'
require 'spec'
require 'rr'
require 'artester'

$LOAD_PATH.unshift('lib')

require 'lib/ologger'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Artester.init
  
Artester.def :game_logger do
  model :foo do
    definition do |t|
      t.string :name
      t.string :bar
    end
  end
end

class A
  def foo
    B.new.bar
  end

  def ologger_module
    'test'
  end
  def ologger_id
    'test'
  end
  include OLogger::Raiser
end

class B
  def bar
    raise 'hehe'
  end
end
