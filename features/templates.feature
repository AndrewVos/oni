Feature: Templates
  In order to respond to request with dynamic html
  As a developer
  I want to be able to render views

  Background:
    Given I have the Oni application:
    """
    require "haml"

    class HomeController < Oni::Controller
      def get
        render(:index)
      end
    end

    Oni::Routes.route "/the_request/path", HomeController
    """

  Scenario: Haml template
    Given I have the template "index.haml" with the contents:
    """
    %p Nothing to see here!
    """
    When I visit "/the_request/path"
    Then I should see "<p>Nothing to see here!</p>"

  Scenario: ERB template
    Given I have the template "index.erb" with the contents:
    """
    Just another <%= "ERB" %> template :/
    """
    When I visit "/the_request/path"
    Then I should see "Just another ERB template :/"
