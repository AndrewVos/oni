require "tilt"

module Oni
  class Template
    def initialize template
      @template = template
    end

    def render scope, options = {}
      options = {:layout => true}.merge(options)

      template = Dir.glob("views/#{@template}.*").first
      layout = Dir.glob("views/layout.*").first
      rendered = Tilt.new(template).render(scope)

      if layout && options[:layout] == true
        rendered = Tilt.new(layout).render { rendered }
      end
      rendered
    end
  end
end
