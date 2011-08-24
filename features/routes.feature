Feature:
  In order to direct request to specific controllers
  As a web developer
  I want to be able to easily specify routes

  Scenario: Unmatched route
    When I visit "/unmatched-route"
    Then I should see a 404 status code


  Scenario: Simple route
    Given I have the Oni controller:
    """
    class HomeController < Oni::Controller
      def get
        "application response"
      end
    end
    """
    And I have the route "/" to the controller "HomeController"
    When I visit "/"
    Then I should see "application response"

  Scenario: Routes with named parameters
    Given I have the Oni controller:
    """
    class HomeController < Oni::Controller
      def get
        params[:parameter1] + ":" + params[:parameter2]
      end
    end
    """
    And I have the route "/route/:parameter1/:parameter2" to the controller "HomeController"
    When I visit "/route/value1/value2"
    Then I should see "value1:value2"
