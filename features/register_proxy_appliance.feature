# Copyright (c) 2015 SUSE LLC.  
# Licensed under the terms of the MIT license.

Feature: I want to setup the proxy appliance
  
  Scenario: Create an activation key for the proxy
    Given I am on the Systems page
      And I follow "Activation Keys" in the left menu
      And I follow "Create Key"  
      When I enter "SUSE proxy appliance" as "description"
      And I enter "SUSE-proxy" as "key"
      And I check "provisioning_entitled" 
      And I click on "Create Activation Key"
      And I should see a "Activation key SUSE proxy appliance has been created." text

  Scenario: I run the proxy setup
    When I register the proxy
    And I copy the ssl certs
    And I run the proxy setup
  
  Scenario: The proxy should be setup and registered
    Given I am on the Systems page
      And I follow "Systems" in the left menu
      And I follow "Proxy" in the left menu
      And I should see a proxy link in the content area
      Then I should be setup
