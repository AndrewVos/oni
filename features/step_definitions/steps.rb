require "tempfile"

Capybara::app = Oni::Application

Given /^I have the Oni application:$/ do |contents|
  path = Tempfile.new("application").path
  File.open(path, "w") do |file|
    file.write(contents)
  end
end

When /^I visit "([^"]*)"$/ do |path|
  visit path
end

Then /^I should see "([^"]*)"$/ do |text|
  page.body.should include text
end
