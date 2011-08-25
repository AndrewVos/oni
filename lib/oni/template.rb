require "tilt"

module Oni
  class Template
    def initialize template
      @template = template
    end

    def render scope
      file = Dir.glob("views/#{@template}.*").first
      Tilt.new(file).render(scope)
    end
  end
end
