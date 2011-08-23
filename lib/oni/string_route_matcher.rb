module Oni
  class StringRouteMatcher
    def match? route, request
      route_parts = route.split("/")
      request_parts = request.path.split("/")
      if route_parts.size == request_parts.size
        parameters = {}
        all_parts_match = true
        0.upto(route_parts.size-1) do |index|
          if route_parts[index] =~ /:\w+/
            parameters[route_parts[index]] = request_parts[index]
          elsif route_parts[index] == request_parts[index]
          else
            all_parts_match = false
          end
        end
        if all_parts_match
          parameters.each do |key, value|
            request.params[key.gsub(":", "").to_sym] = value
          end
          return true
        end
      end

      return route == request.path
    end
  end
end
