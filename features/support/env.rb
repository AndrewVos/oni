$:.unshift File.join(File.dirname(__FILE__), "..", "..", "lib")
require "cucumber"
require "capybara"
require "capybara/cucumber"
require "oni"
require "oni/application"
