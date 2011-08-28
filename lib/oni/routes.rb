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
        [StringRouteProcessor, StaticFileRouteProcessor].each do |processor_class|
          response = processor_class.new(request).process?
          return response if response
        end
        Rack::Response.new([], 404)
      end
    end
  end
end
