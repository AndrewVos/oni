$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rack"
require "oni/version"
require "oni/application"
require "oni/controller"
require "oni/routes"
require "oni/template"
require "oni/string_route_processor"
require "oni/static_file_route_processor"
require "oni/static_file_controller"

module Oni
end
