Feature: Application
  In order to make web development easier
  As a developer
  I want to be able to create web applications easily

  Scenario: Application that responds to get requests
    Given I have the Oni application:
    """
    class HomeController < Oni::Controller
      def get
        "Hello World!"
      end
    end

    Oni::Routes.route "/", HomeController
    """
    When I visit "/"
    Then I should see "Hello World!"
