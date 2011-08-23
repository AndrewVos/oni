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
            parameter_names.flatten!
            parameter_names.map!(&:to_sym)
            new_parameters = Hash[*parameter_names.zip(request_path_parts).flatten]
            new_parameters.each do |key, value|
              request.params[key] = value
            end
            return to.new
          end
        end
        nil
      end
    end
  end
end
