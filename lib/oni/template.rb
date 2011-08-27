require "tilt"

module Oni
  class Template
    def initialize template
      @template = template
    end

    def render scope, options = {}
      options = {:layout => true}.merge(options)

      template = Dir.glob("templates/#{@template}.*").first
      rendered = Tilt.new(template).render(scope)

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

      rendered
    end
  end
end
