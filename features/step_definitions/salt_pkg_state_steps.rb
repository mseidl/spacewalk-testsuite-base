# Copyright (c) 2016 SUSE LLC
# Licensed under the terms of the MIT license.

When(/^I list packages with "(.*?)"$/) do |str|
  find('input#package-search').set(str)
  find('button#search').click
end

When(/^I change the state of "([^"]*)" to "([^"]*)" and "([^"]*)"$/) do |pkg, state, instd_state|
  # Options for state are Installed, Unmanaged and Removed
  # Options for instd_state are Any or Latest
  # Default if you pick Installed is Latest
  find("##{pkg}-pkg-state").select(state)
  if !instd_state.to_s.empty? && state == 'Installed'
    find("##{pkg}-version-constraint").select(instd_state)
  end
end

Then(/^"([^"]*)" is not installed$/) do |package|
  output = `rpm -q #{package} 2>&1`
  puts output
  if  $?.success?
    raise "exec rpm removal failed (Code #{$?}): #{$!}: #{output}"
  end
end

When(/^I click undo for "(.*?)"$/) do |pkg|
  find("button##{pkg}-undo").click
end

When(/^I click apply$/) do
  find('button#apply').click
end

When(/^I click save$/) do
  find('button#save').click
end

When(/^I click system$/) do
  find('button#system').click
end
