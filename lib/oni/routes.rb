module Oni
  class Routes
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

      def process request
        routes.each do |from, to|
          if StringRouteMatcher.new(from, request).match?
            return to.new.process(request)
          end
        end
        Rack::Response.new([], 404)
      end
    end
  end
end
