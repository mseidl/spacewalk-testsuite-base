# Copyright (c) 2015 SUSE LLC
# Licensed under the terms of the MIT license.

Feature: Test SP migration with sles12

  Scenario: I want to add the needed channels
    When I execute mgr-sync "add channel sles12-pool-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles12-pool-x86_64"
    Then I execute mgr-sync "add channel sles12-updates-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles12-updates-x86_64"
    Then I execute mgr-sync "add channel sle-manager-tools12-pool-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sle-manager-tools12-pool-x86_64" 
    Then I execute mgr-sync "add channel sle-manager-tools12-updates-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sle-manager-tools12-updates-x86_64" 
    When I execute mgr-sync "add channel sles12-sp1-pool-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles12-sp1-pool-x86_64"
    Then I execute mgr-sync "add channel sles12-sp1-updates-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles12-updates-x86_64"
    Then I execute mgr-sync "add channel sle-manager-tools12-pool-x86_64-sp1"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sle-manager-tools12-pool-x86_64-sp1" 
    Then I execute mgr-sync "add channel sle-manager-tools12-updates-x86_64-sp1"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sle-manager-tools12-updates-x86_64-sp1"
    Then I wait till sle12 channels are synced

  Scenario: I prepare the virtual machine
    Then I shut off the sle12 vm
    And I revert the sle12 snapshot
    Then I turn on the sle12 vm

  Scenario: I create an activation key for sp migration key
    Given I am on the Systems page
    And I follow "Activation Keys" in the left menu
    And I follow "Create Key"
    When I enter "sp migration key sle12" as "description"
    And I enter "sp_mig_sle12" as "key"
    And I check "monitoring_entitled"
    And I check "provisioning_entitled"
    And I select "SLES12-Pool for x86_64" from "selectedChannel"
    And I click on "Create Activation Key"
    And I follow "Child Channels"
    And I check "SLE-Manager-Tools12-Pool x86_64"
    And I check "SLE-Manager-Tools12-Updates x86_64"
    And I check "SLES12-Updates for x86_64"
    Then I click on "Update Key"   

  Scenario: I register the client
    Given I create the sle12 bootstrap repos
    When I register the sle12 client for sp migration
    Then I verify SLE12SP1 is not installed

  Scenario: I perform the SP migration
    Given I am authorized
    When I follow "Systems"
    And I follow "sumasle12c.suse.de"
    And I follow "Software" in the content area
    And I follow "SP Migration"
    And I click on "Schedule Migration"
    And I click on "Confirm"
    And I run rhn_check on the sle12 sp migration client
    Then I verify 12SP1 is installed
