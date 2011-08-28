require "tempfile"

Capybara::app = Oni::Application.new

Before do
  Oni::Routes.reset_routes!
  FileUtils.mkdir_p("templates")
  FileUtils.mkdir_p("public")
end

After do
  FileUtils.rm_rf("templates")
  FileUtils.rm_rf("public")
end

Given /^I have the Oni application:$/ do |contents|
  eval contents
end

Given /^I have the Oni controller:$/ do |contents|
  eval contents
end

When /^I visit "([^"]*)"$/ do |path|
  visit path
end

Then /^I should see "([^"]*)"$/ do |text|
  page.body.should include text
end

Then /^I should see$/ do |text|
  page.body.should include text
end

Then /^I should not see$/ do |text|
  page.body.should_not include text
end

Given /^I have the route "([^"]*)"$/ do |route|
end

Given /^I have the route "([^"]*)" to the controller "([^"]*)"$/ do |from, to|
  Oni::Routes.route from, Kernel.const_get(to)
end

Given /^I have the template "([^"]*)" with the contents:$/ do |file, contents|
  File.open("templates/#{file}", "w") do |file|
    file.write(contents)
  end
end

Then /^I should see a (\d+) status code$/ do |code|
  page.status_code.should == code.to_i
end

Given /^I have the public file "([^"]*)" with the content$/ do |file, contents|
  File.open("public/#{file}", "w") do |file|
    file.write(contents)
  end
end

Then /^the content type should be "([^"]*)"$/ do |content_type|
  page.response_headers["Content-Type"].should == content_type
end
