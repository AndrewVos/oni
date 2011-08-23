$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "rack"
require "oni/version"
require "oni/application"
require "oni/controller"
require "oni/routes"
require "oni/string_route_matcher"

module Oni
end
