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
        response["Content-Type"] = @content_type if @content_type
        response
      end
    end

    def render template, options = {}
      rendered_template = Template.new(template).render(self, options)
      content_type(rendered_template.content_type) if rendered_template.content_type
      rendered_template.body
    end

    def content_type type
      @content_type = type
      @content_type = Rack::Mime.mime_type(type, nil) if type.start_with? '.'
    end
  end
end
