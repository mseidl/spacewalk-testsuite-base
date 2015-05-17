# COPYRIGHT 2015 SUSE LLC

When /^I mount the nfs share$/ do
  cmd = 'mount schnell://schnell /mnt'
  sshcmd(cmd)  
end

When /^I want to configure cobbler$/ do
  ip = sshcmd("ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'", ignore_err: true)[:stdout]
  cmd = "cobbler system add --name pxesys --profile=sles11sp3-64:1:Novell --server=#{ip} --mac=52:54:00:08:c5:e7"
  sshcmd(cmd)
end

When /^I start the pxeboot client$/ do
  cmd = "virsh destroy sumapxe; virsh start sumapxe"
  result = ssh_cmd(cmd, host: ENV['SUMAPXE_VHOST'], ignore_err: true)
  raise if ! result.include? 'Domain sumapxe started'
end
