Feature: Templates
  In order to respond to request with dynamic html
  As a developer
  I want to be able to render views

  Background:
    Given I have the Oni application:
    """
    require "haml"

    class HomeController < Oni::Controller
      attr_reader :value
      def get
        @value = "the value of value"
        render(:index)
      end
    end

    Oni::Routes.route "/the_request/path", HomeController
    """

  Scenario: Templates can see the controller binding
    Given I have the template "index.haml" with the contents:
    """
    = value
    """
    When I visit "/the_request/path"
    Then I should see "the value of value"

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
