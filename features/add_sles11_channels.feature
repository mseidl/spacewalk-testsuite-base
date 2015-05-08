# Copyright (c) 2015 SUSE LLC.
# Licensed under the terms of the MIT license.

Feature: Sync the necessary channels for the proxy

  Scenario: I add the channels for the proxy
     And I execute ncc-sync "-c sles11-sp3-pool-x86_64"
     And I execute ncc-sync "-c sles11-sp3-updates-x86_64"
     And I execute ncc-sync "-c sles11-sp3-suse-manager-tools-x86_64"
