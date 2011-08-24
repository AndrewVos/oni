require "tilt"

module Oni
  class Template
    def initialize template
      @template = template
    end

    def render
      file = Dir.glob("views/#{@template}.*").first
      Tilt.new(file).render
    end
  end
end
