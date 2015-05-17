# COPYRIGHT 2015 SUSE LLC

When /^I mount the nfs share$/ do
  cmd = 'mount schnell://schnell /mnt'
  sshcmd(cmd)  
end

When /^I want to configure cobbler$/ do
  ip = sshcmd("ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'", ignore_err: true)[:stdout]
  puts ip.chomp!
  cmd = "cobbler system add --name pxesys --profile=sles11sp3-64:1:Novell --server=#{ip} --mac=52:54:00:08:c5:e7"
  puts cmd
  sshcmd(cmd, ignore_err: true)
end

When /^I start the pxeboot client$/ do
  cmd = "virsh destroy sumapxe; virsh start sumapxe"
  result = sshcmd(cmd, host: ENV['SUMAPXE_VHOST'], ignore_err: true)
  raise if ! result.include? 'Domain sumapxe started'
end

Then /^I wait till channels are synced$/ do
  log = '/var/log/rhn/reposync/sles11-sp3-suse-manager-tools-x86_64.log'
  cmd = "grep 'Sync completed' #{log}"
  while true 
    out = sshcmd(cmd, ignore_err: true)[:stdout]
    break if out.include? 'Sync completed.'
    sleep 600
  end
end
