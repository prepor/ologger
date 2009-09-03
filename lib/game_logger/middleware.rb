module GameLogger
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      GameLogger.buffer.flush
      @status, @headers, @response = @app.call(env)
      GameLogger.buffer.write
      [@status, @headers, self]
    end
  
    def each(&block)
      @response.each(&block)
    end

  end
end