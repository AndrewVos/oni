Feature: Controllers
  In order to isolate my controller logic into objects
  As a developer
  I want to be able to access request data inside the controller

  Scenario: Controller can access request object
    Given I have the Oni application:
    """
    class HomeController < Oni::Controller
      def get
        request.path
      end
    end

    Oni::Routes.route "/the_request/path", HomeController
    """
    When I visit "/the_request/path"
    Then I should see "/the_request/path"
