module Oni
  class Application
    class << self
      def routes
        @routes ||= {}
        @routes
      end

      def route from, to
        routes[from] = to
      end

      def reset_routes!
        @routes = {}
      end
    end

    def call env
      process Rack::Request.new(env)
    end

    def process request
      Application.routes.each do |from, to|
        if request.path == from
          controller = to.new
          return Rack::Response.new([controller.get])
        end
      end
      ["404", {"Content-Type" => "text/plain"}, ["404"]]
    end
  end
end
