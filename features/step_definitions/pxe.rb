# COPYRIGHT 2015 SUSE LLC

When /^I mount the nfs share$/ do
  cmd = 'mount schnell://schnell /mnt'
  sshcmd(cmd)  
end

When /^I want to configure cobbler$/ do
  cmd = "cobbler system add --name pxesys --profile=sles11sp3-64:1:Novell --mac=52:54:00:08:c5:e7"
  sshcmd(cmd, ignore_err: true)
end

When /^I sync the proxy and server$/ do
  # First run on proxy
  cmd = '/usr/sbin/configure-tftpsync.sh --non-interactive'
  sshcmd(cmd, host: ENV['PROXY_APP'], ignore_err: true)
  # Then run on server
  scmd = "/usr/sbin/configure-tftpsync.sh #{ENV['PROXY_APP']} && cobbler sync"
  sshcmd(scmd)
end

When /^I start the pxeboot client$/ do
  cmd = "virsh destroy sumapxe; virsh start sumapxe"
  result = sshcmd(cmd, host: ENV['SUMAPXE_VHOST'], ignore_err: true)[:stdout]
  raise if ! result.include? 'Domain sumapxe started'
end

When /^I wait till the client is up$/ do
  sleep 600
  while true
    $cmd_out = `ping -c1 sumapxe`  # ip of sumapxe
    break if $?.success?
    sleep 60
  end
end

When /^I congigure the servers 2nd lan$/ do
end

When /^I wait till channels are synced$/ do
  log = '/var/log/rhn/reposync/sles11-sp3-suse-manager-tools-x86_64.log'
  cmd = "grep 'Sync completed' #{log}"
  while true 
    out = sshcmd(cmd, ignore_err: true)[:stdout]
    break if out.include? 'Sync completed.'
    sleep 60
  end
end

When /^I wait till sp4 channels are synced$/ do
  log = '/var/log/rhn/reposync/sles11-sp4-suse-manager-tools-x86_64.log'
  cmd = "grep 'Sync completed' #{log}"
  while true 
    out = sshcmd(cmd, ignore_err: true)[:stdout]
    break if out.include? 'Sync completed.'
    sleep 60
  end
end

When /^I wait till sle12 channels are synced$/ do
  log = '/var/log/rhn/reposync/sle-manager-tools12-x86_64-sp1.log'
  cmd = "grep 'Sync completed' #{log}"
  while true 
    out = sshcmd(cmd, ignore_err: true)[:stdout]
    break if out.include? 'Sync completed.'
    sleep 60
  end
end
