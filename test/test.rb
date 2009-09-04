require 'test/test_helper'

describe OLogger do
  describe "Object with game logger" do
    before(:each) do
      OLogger.buffer.flush
      Object.send :include, OLogger
      @obj = Object.new
      
    end
    it "should add message to buffer" do
      mock(OLogger.buffer).add(hash_including(:message => 'hi!'))
      @obj.game_logger 'hi!'
    end
    
    it "should add objects to buffer" do
      mock(OLogger.buffer).add(hash_including(:message => 'hi!', :objs => [{ :foo => :bar}, { :bar => :foo}]))
      @obj.game_logger 'hi!', { :foo => :bar}, { :bar => :foo}
    end
  end
  
  describe "ActiveRecord object with game logger" do    
    before(:each) do
      # require 'ruby-debug'
      # debugger
      Artester[:game_logger].reload
      OLogger.buffer.flush
      Object.send :include, OLogger
      @obj = Object.new
      @ar_obj = Foo.create :name => 'tester', :bar => 'hi!'
    end
    
    it "should insert link to ar object" do
      # mock(OLogger.buffer).add(hash_including(:message => 'Self:', :objs => [{"name"=>"tester", "id"=>1, "bar"=>"hi!"}]))
      mock(OLogger.buffer).add(hash_including(:message => 'hi!', :objs => ["g#foos.#{@ar_obj.id}#"]))
      stub(OLogger.buffer).add
      @obj.game_logger 'hi!', @ar_obj
    end
    
    it "should insert itsel description to ar object log" do
      mock(OLogger.buffer).add(hash_including(:message => 'Self:', :objs => [{"name"=>"tester", "id"=>1, "bar"=>"hi!"}]))      
      stub(OLogger.buffer).add
      
      @obj.game_logger 'hi!', @ar_obj
    end
    
    it "should raise exceptions" do
      mock(OLogger.buffer).add(hash_including(:message => "Exception:"))
      OLogger.enable do
        Foo.find(10)
      end
    end
    
    describe "writing" do
      
      before(:all) do
        OLogger.path = Pathname.new('test/ologs')
        OLogger.path.rmtree if OLogger.path.exist?
      end
      
      after(:each) do
        OLogger.path.rmtree if OLogger.path.exist?
      end
      
      it "should write logs to file" do
        path = OLogger.path + 'foos' + "#{@ar_obj.id}.log"
        path.exist?.should be_false
        OLogger.enable do
          @ar_obj.game_logger 'hi!'
        end
        path.exist?.should be_true
      end
      
      describe "garbage collecting" do
        before(:each) do          
          stub(OLogger).needed_to_remove { true }
          OLogger.enable do
            @ar_obj.game_logger 'hi!'
          end
        end
        it "should remove all big and old logs" do
          (OLogger.path + 'foos' + "#{@ar_obj.id}.log").exist?.should be_true
          OLogger.gc
          (OLogger.path + 'foos' + "#{@ar_obj.id}.log").exist?.should be_false
        end
      end
    end
    
  end
  
end