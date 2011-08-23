module Oni
  class Application
    def call env
      process(Rack::Request.new(env))
    end

    def process request
      Routes.process(request)
    end
  end
end
