require 'rubygems'
require 'test/unit'
require 'spec'
require 'rr'
require 'artester'

$LOAD_PATH.unshift('lib')

require 'lib/game_logger'

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