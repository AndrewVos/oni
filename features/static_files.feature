Feature: Static Files
  In order to deliver static files
  As  a developer
  I want to be able to serve static files

  Scenario: CSS File
    Given I have the public file "main.css" with the content
    """
    body { }
    """
    When I visit "/main.css"
    Then I should see
    """
    body { }
    """
    And the content type should be "text/css"
