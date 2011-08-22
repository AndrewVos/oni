module Oni
  class Application
    def call env
      process(Rack::Request.new(env))
    end

    def process request
      controller = Routes.match(request)
      if controller
        controller.process(request)
      else
        Rack::Response.new([], 404)
      end
    end
  end
end
