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

When /^I register the client for sp migration$/ do
  regurl = "http://#{ENV['TESTHOST']}/XMLRPC"
  key = '1-sp_mig'
  bs_cmd = "mgr-bootstrap --activation-keys=#{key} --no-up2date --script=spbs.sh"
  cmd = "rhnreg_ks --serverUrl=#{regurl} --activationkey=#{key}"
  reg_cmd = "wget http://#{ENV['TESTHOST']}/pub/bootstrap/spbs.sh && sh spbs.sh"
  sshcmd(bs_cmd)
  sshcmd(reg_cmd, host: "sumapxc.suse.de", ignore_err: true)
end

When /^I run rhn_check on the sp migration client$/ do
  sshcmd("rhn_check", host: "sumapxc.suse.de")
end

When /^I verify SP4 is installed$/ do
  cmd = 'cat /etc/issue | grep -o SP4'
  out = sshcmd(cmd, host: 'sumapxc.suse.de')[:stdout]
  fail if not out.include? 'SP4'
end

When /^I verify SP3 is installed$/ do
  cmd = 'cat /etc/issue | grep -o SP3'
  out = sshcmd(cmd, host: 'sumapxc.suse.de')[:stdout]
  fail if not out.include? 'SP3'
end
