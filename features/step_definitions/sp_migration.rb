# Copyright (c) 2015 SUSE LLC
# This is licensed under the terms of the MIT license.

When /^I shut off the vm$/ do
  turn_off = 'virsh destroy sumapxc'
  sshcmd(turn_off, host:  ENV['SUMAPXE_VHOST'],  ignore_err: true)
end

When /^I revert the snapshot$/ do
  set_snapshot = 'qemu-img snapshot -a freshsp3 /images/sumapxc/sumapxc.qcow2'
  sshcmd(set_snapshot, host:  ENV['SUMAPXE_VHOST'])
end

When /^I turn on the vm$/ do
  turn_on = 'virsh start sumapxc'
  sshcmd(turn_on, host:  ENV['SUMAPXE_VHOST'],  ignore_err: true)
end
