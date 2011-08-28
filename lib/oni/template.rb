require "tilt"

module Oni
  class Template
    def initialize template
      @template = template
    end

    def render scope, options = {}
      options = {:layout => true}.merge(options)

      template = Dir.glob("templates/#{@template}.*").first
      template = Tilt.new(template)
      rendered = template.render(scope)

      if options[:layout] != false
        if options[:layout] == true
          layout = Dir.glob("templates/layout.*").first
        else
          layout = Dir.glob("templates/#{options[:layout]}.*").first
        end
        if layout
          rendered = Tilt.new(layout).render { rendered }
        end
      end

      content_type = template.class.default_mime_type
      RenderedTemplate.new(rendered, content_type)
    end
  end

  class RenderedTemplate
    attr_accessor :body, :content_type
    def initialize body, content_type
      @body = body
      @content_type = content_type
    end
  end
end
