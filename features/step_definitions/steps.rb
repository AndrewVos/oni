require "tempfile"

Capybara::app = Oni::Application.new

Before do
  Oni::Routes.reset_routes!
end

Given /^I have the Oni application:$/ do |contents|
  eval contents
end

When /^I visit "([^"]*)"$/ do |path|
  visit path
end

Then /^I should see "([^"]*)"$/ do |text|
  page.body.should include text
end
