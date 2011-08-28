module Oni
  class StringRouteMatcher
    def initialize request
      @request = request
    end

    def match?
      Routes.routes.each do |route, controller|
        if try_match? route, controller
          return controller.new.process(@request)
        end
      end

      false
    end

    private

    def try_match? route, controller
      route_parts = route.split("/")
      request_parts = @request.path.split("/")
      return false if route_parts.size != request_parts.size

      0.upto(route_parts.size-1).map do |index|
        unless route_parts[index].start_with? ':'
          return false if route_parts[index] != request_parts[index]
        end
      end
      rip_parameters(route_parts, request_parts).each do |key, value|
        @request.params[key] = value
      end

      true
    end

    def rip_parameters route_parts, request_parts
      parameters = {}
      0.upto(route_parts.size-1) do |index|
        if route_parts[index].start_with? ':'
          symbol = route_parts[index].gsub(':', '').to_sym
          parameters[symbol] = request_parts[index]
        end
      end
      parameters
    end
  end
end
