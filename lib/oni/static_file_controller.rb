module Oni
  class StaticFileController < Controller
    def get
      content_type(File.extname(request.path))
      File.read(File.join("public", request.path))
    end
  end
end
