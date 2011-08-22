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

      def match request
        routes.each do |from, to|
          parameter_names = from.scan(/:(\w+)/)
          request_path_parts = request.path.scan(/\/(\w+)/)
          if parameter_names.size == request_path_parts.size
            return to.new
          end
        end
        nil
      end
    end
  end
end
