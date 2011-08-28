module Oni
  class StaticFileRouteProcessor
    def initialize request
      @request = request
    end

    def process?
      public_path = File.expand_path("public")
      path = File.expand_path(File.join(public_path, @request.path))
      if path.start_with?(public_path) && File.exist?(path)
        return StaticFileController.new.process(@request)
      end
      false
    end
  end
end
