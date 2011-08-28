module Oni
  class Controller
    REQUEST_METHODS = ["GET", "PUT", "POST", "DELETE", "HEAD", "OPTIONS", "PATCH"]

    attr_reader :params, :request

    def process request
      @params = request.params
      @request = request

      if REQUEST_METHODS.include?(request.request_method)
        body = send(request.request_method.downcase.to_sym)
        response = Rack::Response.new([body])
        response["Content-Type"] = @content_type
        response
      end
    end

    def render template, options = {}
      Template.new(template).render(self, options)
    end

    def content_type type
      @content_type = Rack::Mime.mime_type(type, nil)
    end
  end
end
