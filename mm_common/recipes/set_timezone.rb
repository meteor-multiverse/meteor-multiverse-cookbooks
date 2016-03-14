################################################################################
#
# SUGGESTED USE:
#
# Include this recipe in ONE of the following AWS OpsWorks Lifecycle Phases:
#  - Setup
#  - Deploy
#
################################################################################


# TZ Database formats preferred but other formats like 'CST6CDT' should work
node.default['mm']['common']['timezone'] = 'America/Chicago'


# Set the local timezone of this server
bash "Set the server timezone to #{node['mm']['common']['timezone']}" do
  user 'root'
  code <<-EOH
ln -sf /usr/share/zoneinfo/#{node['mm']['common']['timezone']} /etc/localtime
EOH
end
