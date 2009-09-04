module OLogger
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      OLogger.buffer.flush
      @status, @headers, @response = @app.call(env)
      OLogger.buffer.write
      [@status, @headers, self]
    end
  
    def each(&block)
      @response.each(&block)
    end

  end
end