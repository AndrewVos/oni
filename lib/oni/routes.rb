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
        [StringRouteMatcher, StaticFileRouteMatcher].each do |matcher_class|
          response = matcher_class.new(request).match?
          return response if response
        end
        Rack::Response.new([], 404)
      end
    end
  end
end
