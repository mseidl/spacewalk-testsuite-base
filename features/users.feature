# Copyright (c) 2015 SUSE LLC
# Licensed under the terms of the MIT license.

@simple
Feature: Check users page/tab
  Validate users page accessibility

  Scenario: Check users page content
    Given I am on the Users page
    Then I should see a "Active Users" text
    And I should see a "Create User" link
    And I should see a "User List" link in the left menu
    And I should see a "Active" link in the left menu
    And I should see a "Deactivated" link in the left menu
    And I should see a "All" link in the left menu
    And I should see a "admin" link in the table first column
    And I should see a "Download CSV" link
