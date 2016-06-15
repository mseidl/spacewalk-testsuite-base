# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

#
# Initial step for channel testing
#
Given(/^I am testing channels$/) do
  step %[I am authorized as "admin" with password "admin"]
end

Then(/^I should see package "([^"]*)"$/) do |package|
  fail if not has_xpath?("//div[@class=\"table-responsive\"]/table/tbody/tr/td/a[contains(.,'#{package}')]")
end

Given(/^I am on the manage software channels page$/) do
  step %[I am authorized as "testing" with password "testing"]
  within(:xpath, "//header") do
    find_link("Channels").click
  end
  step %[I follow "Manage Software Channels" in the left menu]
end

Given(/^metadata generation finished for "([^"]*)"$/) do |channel|
  for c in 0..60
      begin
          sshcmd('ls /var/cache/rhn/repodata/#{channel}/updateinfo.xml.gz')
      rescue
          sleep 2
      else
          break
      end
  end
end

When(/^I choose "([^"]*)" for "([^"]*)"$/) do |arg1, arg2|
  within(:xpath, "//div[@class=\"table-responsive\"]/table/tbody/tr[.//a[contains(.,'#{arg2}')]]") do
    find(:xpath, './/select').select(arg1)
  end
end

When(/^I push package "([^"]*)" into "([^"]*)" channel$/) do |arg1, arg2|
  srvurl = "http://#{ENV['TESTHOST']}/APP"
  command = "rhnpush --server=#{srvurl} -u admin -p admin --nosig -c #{arg2} #{arg1} "
  out , local_err, remote_err, code = $server.test_and_store_results_together(command, "root", 500)
  puts out

  out , local_err, remote_err, ret_code = $server.test_and_print_results("ls -lR /var/spacewalk/packages", "root", 500)
  
  if code != 0
    raise "rhnpush failed '#{out}"
  end
end

Then(/^I should see package "([^"]*)" in channel "([^"]*)"$/) do |arg1, arg2|
  steps %[
    When I am authorized as "admin" with password "admin"
    And I follow "Channels"
    And I follow "#{arg2}"
    And I follow "Packages"
    Then I should see package "#{arg1}"
  ]
end

Then(/^I should see a "([^"]*)" text in the "([^"]*)" column$/) do |arg1, arg2|
  within(:xpath, "//*[@class=\"details\"]/table/tbody/tr[.//th[contains(.,'#{arg2}')]]") do
    find("td", :text => "#{arg1}")
  end
end
