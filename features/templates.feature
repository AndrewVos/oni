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

    class ValueReturnerController < Oni::Controller
      attr_reader :value
      def get
        @value = "the value of value"
      end
    end
    Oni::Routes.route "/value_controller", ValueReturnerController

    class LayoutlessController < Oni::Controller
      def get
        render(:index, :layout => false)
      end
    end
    Oni::Routes.route "/no-layout", LayoutlessController
    """

  Scenario: Templates can see the controller binding
    Given I have the template "layout.haml" with the contents:
    """
    = yield
    """
    And I have the template "index.haml" with the contents:
    """
    HAML Template Title
    = value
    """
    When I visit "/value_controller"
    Then I should see "the value of value"

  Scenario: Template without a layout
    Given I have the template "layout.haml" with the contents:
    """
    %p Template Title
    = yield
    """
    Given I have the template "index.haml" with the contents:
    """
    %p Template Content
    """
    When I visit "/no-layout"
    Then I should not see
    """
    <p>Template Title</p>
    """
    And I should see
    """
    <p>Template Content</p>
    """

  Scenario: Haml template
    Given I have the template "layout.haml" with the contents:
    """
    %p HAML Template Title
    = yield
    """
    And I have the template "index.haml" with the contents:
    """
    %p Nothing to see here!
    """
    When I visit "/the_request/path"
    Then I should see
    """
    <p>HAML Template Title</p>
    <p>Nothing to see here!</p>
    """

  Scenario: ERB template
    Given I have the template "layout.erb" with the contents:
    """
    ERB Template Title
    <%= yield %>
    """
    And I have the template "index.erb" with the contents:
    """
    Just another <%= "ERB" %> template :/
    """
    When I visit "/the_request/path"
    Then I should see
    """
    ERB Template Title
    Just another ERB template :/
    """
