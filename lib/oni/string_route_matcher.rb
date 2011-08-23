module Oni
  class StringRouteMatcher
    def initialize route, request
      @route = route
      @request = request
    end

    def match?
      route_parts = @route.split("/")
      request_parts = @request.path.split("/")
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

    private

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
