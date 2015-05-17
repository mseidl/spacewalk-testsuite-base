# COPYRIGHT 2015 SUSE LLC 

Feature:  I want to setup pxe installations

  Scenario: I want to mount the nfs directory
    Given I mount the nfs share

  Scenario: I want to add the installer tree to autoinstallation
    Given I am on the Systems page
    And I follow "Kickstart" in the left menu
    And I follow "Distributions" in the left menu
    And I follow "Create Distribution"
    When I enter "sles11sp3-64" as "label"
    And I enter "/mnt/CD-ARCHIVE/SLE11/SLES-11-SP3-GM/x86_64/DVD1" as "basepath"
    And I click on "Create Autoinstallable Distribution"
    Then I should see a "Autoinstallable Distribution Created" text

  Scenario: I want to add the profile to the disribution
    Given I am on the Systems page
    And I follow "Kickstart" in the left menu
    And I follow "Profiles" in the left menu
    And I follow "Upload Kickstart File"
    When I enter "sles11sp3-64" as "kickstartLabel"
    And I select "sles11sp3-64" from "kstreeId"
    And I attach the file "/sles11-sp3.xml" to "fileUpload"
    And I click on "Upload File" 
    Then I should see a "Kickstart: sles11sp3-64" text

  Scenario: I want to pxe boot the machine
    Given I to configure cobbler
    And I start the pxeboot client
