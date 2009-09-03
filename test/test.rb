require 'test/test_helper'

describe GameLogger do
  describe "Object with game logger" do
    before(:each) do
      GameLogger.buffer.flush
      Object.send :include, GameLogger
      @obj = Object.new
      
    end
    it "should add message to buffer" do
      mock(GameLogger.buffer).add(hash_including(:message => 'hi!'))
      @obj.game_logger 'hi!'
    end
    
    it "should add objects to buffer" do
      mock(GameLogger.buffer).add(hash_including(:message => 'hi!', :objs => [{ :foo => :bar}, { :bar => :foo}]))
      @obj.game_logger 'hi!', { :foo => :bar}, { :bar => :foo}
    end
  end
  
  describe "ActiveRecord object with game logger" do    
    before(:each) do
      # require 'ruby-debug'
      # debugger
      Artester[:game_logger].reload
      GameLogger.buffer.flush
      Object.send :include, GameLogger
      @obj = Object.new
      @ar_obj = Foo.create :name => 'tester', :bar => 'hi!'
    end
    
    it "should insert link to ar object" do
      # mock(GameLogger.buffer).add(hash_including(:message => 'Self:', :objs => [{"name"=>"tester", "id"=>1, "bar"=>"hi!"}]))
      mock(GameLogger.buffer).add(hash_including(:message => 'hi!', :objs => ["g#foos.#{@ar_obj.id}#"]))
      stub(GameLogger.buffer).add
      @obj.game_logger 'hi!', @ar_obj
    end
    
    it "should insert itsel description to ar object log" do
      mock(GameLogger.buffer).add(hash_including(:message => 'Self:', :objs => [{"name"=>"tester", "id"=>1, "bar"=>"hi!"}]))      
      stub(GameLogger.buffer).add
      
      @obj.game_logger 'hi!', @ar_obj
    end
    
    it "should raise exceptions" do
      mock(GameLogger.buffer).add(hash_including(:message => "Exception:"))
      GameLogger.enable do
        Foo.find(10)
      end
    end
    
    describe "writing" do
      
      before(:all) do
        GameLogger.path = Pathname.new('test/game_logs')
        GameLogger.path.rmtree if GameLogger.path.exist?
      end
      
      after(:each) do
        GameLogger.path.rmtree
      end
      
      it "should write logs to file" do
        path = GameLogger.path + 'foos' + "#{@ar_obj.id}.log"
        path.exist?.should be_false
        GameLogger.enable do
          @ar_obj.game_logger 'hi!'
        end
        path.exist?.should be_true
      end
    end
    
  end
  
end