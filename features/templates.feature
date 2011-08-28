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
        render :index
      end
    end
    Oni::Routes.route "/value_controller", ValueReturnerController

    class LayoutlessController < Oni::Controller
      def get
        render(:index, :layout => false)
      end
    end
    Oni::Routes.route "/no-layout", LayoutlessController

    class NonDefaultLayoutController < Oni::Controller
      def get
        render(:index, :layout => :"non-default")
      end
    end
    Oni::Routes.route "/non-default-layout", NonDefaultLayoutController
    """

  Scenario: Templates can see the controller binding
    Given I have the template "layout.haml" with the contents:
    """
    = "The layout can see the controller binding: " + value
    = yield
    """
    And I have the template "index.haml" with the contents:
    """
    = "And so can the template: " + value
    """
    When I visit "/value_controller"
    Then I should see
    """
    The layout can see the controller binding: the value of value
    And so can the template: the value of value
    """

  Scenario: Template without a layout
    Given I have the template "layout.haml" with the contents:
    """
    %p Template Title
    = yield
    """
    And I have the template "index.haml" with the contents:
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

  Scenario: Template with non-default layout
    Given I have the template "non-default.haml" with the contents:
    """
    %p Template with non-default layout
    = yield
    """
    And I have the template "index.haml" with the contents:
    """
    %p Non-default Template Content
    """
    When I visit "/non-default-layout"
    Then I should see
    """
    <p>Template with non-default layout</p>
    <p>Non-default Template Content</p>
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

  Scenario: Sass template
    Given I have the template "index.sass" with the contents:
    """
    #element
      color: red
    """
    When I visit "/the_request/path"
    Then the content type should be "text/css"
