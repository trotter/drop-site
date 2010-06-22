Feature: Beta Signup
  As a user
  I want to signup for the beta
  In order to get access to the service

  Scenario: Signing Up With a Valid Email
    Given I am on the root page
    When I fill in "Email Address" with "test@example.com"
    And I press "Sign-up Now"
    Then I should see "Thank You"
    When I follow "Click here"
    Then I should see "Register for"

  Scenario: Signing up with an invalid email
    Given I am on the root page
    When I fill in "Email Address" with "blah"
    And I press "Sign-up Now"
    Then I should see "invalid"
