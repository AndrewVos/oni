module Oni
  class Controller
    REQUEST_METHODS = ["GET", "PUT", "POST", "DELETE", "HEAD", "OPTIONS", "PATCH"]

    attr_reader :params

    def process request
      @params = request.params

      if REQUEST_METHODS.include?(request.request_method)
        body = send(request.request_method.downcase.to_sym)
        Rack::Response.new([body])
      end
    end
  end
end
