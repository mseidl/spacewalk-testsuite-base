# Copyright (c) 2015 SUSE LLC
# This is licensed under the terms of the MIT license.

When /^I shut off the vm$/ do
  turn_off = 'virsh destroy sumapxc'
  sshcmd(turn_off, host:  ENV['SUMAPXE_VHOST'],  ignore_err: true)
end

When /^I shut off the sle12 vm$/ do
  turn_off = 'virsh destroy sles12ltt'
  sshcmd(turn_off, host:  ENV['SUMAPXE_VHOST'],  ignore_err: true)
end

When /^I revert the sle12 snapshot$/ do
  set_snapshot = 'qemu-img snapshot -a fresh /images/sles12ltt/sles12ltt.qcow2'
  sshcmd(set_snapshot, host:  ENV['SUMAPXE_VHOST'])
end

When /^I revert the snapshot$/ do
  set_snapshot = 'qemu-img snapshot -a freshsp3 /images/sumapxc/sumapxc.qcow2'
  sshcmd(set_snapshot, host:  ENV['SUMAPXE_VHOST'])
end

When /^I turn on the vm$/ do
  turn_on = 'virsh start sumapxc'
  sshcmd(turn_on, host:  ENV['SUMAPXE_VHOST'],  ignore_err: true)
end

When /^I turn on the sle12 vm$/ do
  turn_on = 'virsh start sles12ltt'
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

When /^I register the sle12 client for sp migration$/ do
  regurl = "http://#{ENV['TESTHOST']}/XMLRPC"
  key = '1-sp_mig_sle12'
  bs_cmd = "mgr-bootstrap --activation-keys=#{key} --up2date --script=spbs.sh"
  cmd = "rhnreg_ks --serverUrl=#{regurl} --activationkey=#{key}"
  reg_cmd = "wget http://#{ENV['TESTHOST']}/pub/bootstrap/spbs.sh && sh spbs.sh"
  sshcmd(bs_cmd)
  sshcmd(reg_cmd, host: "sumasle12c.suse.de", ignore_err: true)
end

When /^I create the sle12 bootstrap repos$/ do
  cmd = 'mgr-create-bootstrap-repo -c SLE-12-x86_64 && mgr-create-bootstrap-repo -c SLE-12-SP1-x86_64'
  sshcmd(cmd)
end

When /^I run rhn_check on the sp migration client$/ do
  sshcmd("rhn_check", host: "sumapxc.suse.de")
end

When /^I run rhn_check on the sle12 sp migration client$/ do
  sshcmd("rhn_check", host: "sumasle12c.suse.de")
end

When /^I verify SP4 is installed$/ do
  cmd = 'cat /etc/issue | grep -o SP4'
  out = sshcmd(cmd, host: 'sumapxc.suse.de')[:stdout]
  fail if not out.include? 'SP4'
end

When /^I verify 12SP1 is installed$/ do
  cmd = 'cat /etc/issue | grep -o SP1'
  out = sshcmd(cmd, host: 'sumasle12c.suse.de')[:stdout]
  fail if not out.include? 'SP1'
end

When /^I verify SLE12SP1 is not installed$/ do
  cmd = 'cat /etc/issue | grep -o SP1'
  out = sshcmd(cmd, host: 'sumasle12c.suse.de')[:stdout]
  fail if out.include? 'SP1'
end

When /^I verify SP3 is installed$/ do
  cmd = 'cat /etc/issue | grep -o SP3'
  out = sshcmd(cmd, host: 'sumapxc.suse.de')[:stdout]
  fail if not out.include? 'SP3'
end
