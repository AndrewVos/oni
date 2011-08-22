Feature: Application
  In order to make web development easier
  As a developer
  I want to be able to create web applications easily

  Scenario: Most basic application
    Given I have the Oni application:
    """
    class HomeController
      def get
        "Hello World!"
      end
    end

    Oni::Application.route "/", HomeController
    """
    When I visit "/"
    Then I should see "Hello World!"
