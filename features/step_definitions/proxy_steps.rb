Then /^I register the proxy$/ do
  # create bootstrap script
  bs_cmd = 'mgr-bootstrap --activation-keys=1-SUSE-proxy --no-up2date'
  sshcmd(bs_cmd)
  # bootstrap script url
  bs_url = "http://#{ENV['TESTHOST']}/pub/bootstrap/bootstrap.sh"
  sshcmd("wget -o /dev/null #{bs_url}", host: ENV['PROXY_APP'], ignore_err: true)
  # Don't disable local repos
  change_bs = "sed -i 's/DISABLE_LOCAL_REPOS=1/DISABLE_LOCAL_REPOS=0/' /root/bootstrap.sh"
  sshcmd(change_bs, host: ENV['PROXY_APP'])
  # Register the proxy
  sshcmd("sh /root/bootstrap.sh", host: ENV['PROXY_APP'], ignore_err: true)
end

Then /^I run the proxy setup$/ do
  step "I change the server in the answer file"
  cmd = "/usr/sbin/configure-proxy.sh --answer-file=/root/proxy_answers --non-interactive"
  sshcmd(cmd, host: ENV['PROXY_APP'])
end

Then /^I change the server in the answer file$/ do
  cmd = "sed -i 's/sumas.*/#{ENV['TESTHOST']}/g' /root/proxy_answers"
  sshcmd(cmd, host: ENV['PROXY_APP'])
  cmd2 = "sed -i 's/sumap.*/#{ENV['PROXY_APP']}/g' /root/proxy_answers"
  sshcmd(cmd2, host: ENV['PROXY_APP'])
end

Then /^I copy the ssl certs$/ do
  certs = "/root/ssl-build/{RHN-ORG-PRIVATE-SSL-KEY,RHN-ORG-TRUSTED-SSL-CERT,rhn-ca-openssl.cnf}"
  dest = "/root/ssl-build"
  scpcmd = "scp -o StrictHostKeyChecking=no '#{ENV['TESTHOST']}:#{certs}' #{dest} &> /dev/null"
  sshcmd("mkdir /root/ssl-build", host: ENV['PROXY_APP'])
  sshcmd(scpcmd, host: ENV['PROXY_APP'], ignore_err: true)
end

Then /^I should be setup$/ do
  sshcmd('pgrep squid', host: ENV['PROXY_APP']) 
  sshcmd('test -x /etc/sysconfig/rhn/systemid', host: ENV['PROXY_APP']) 
end

Then /^I rehash the certificates$/ do
  symbolic_link_cmd = 'ln -s /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT /etc/ssl/certs/RHN-ORG-TRUSTED-SSL-CERT.pem'
  rehash_cmd = 'c_rehash /etc/ssl/certs/'
  sshcmd(symbolic_link_cmd, host: ENV['PROXY_APP'])
  sshcmd(rehash_cmd, host: ENV['PROXY_APP'])
end

Then /^I should see a proxy link in the content area$/ do
  step "I should see a \"#{ENV['PROXY_APP']}\" link in the content area"
end

Then /^I remove the "([^"]*)" package$/ do |pkg|
  $command_output = `zypper --non-interactive rm #{pkg}`
  if ! $?.success?
    raise "Removing package #{pkg} failed"
  end  
end

Then /^I verify the proxy cache$/ do
  squid_log = "/var/log/squid/access.log"
  cmd = "grep 'TCP_MEM_HIT/200' #{squid_log}"
  out = sshcmd(cmd, host: ENV['PROXY_APP'], ignore_err: true)
  fail if ! out[:stdout].include? "hoag-dummy"
end
