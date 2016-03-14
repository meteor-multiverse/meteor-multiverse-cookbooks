################################################################################
#
# SUGGESTED USE:
#
# Include this recipe in ANY of the following AWS OpsWorks Lifecycle Phases:
#  - Setup
#  - Configure
#  - Deploy
#  - Undeploy
#  - Shutdown
#
################################################################################


# Disabled by default
node.default['mm']['common']['debug_chef']['compilation'] = false
node.default['mm']['common']['debug_chef']['convergence'] = false


# If Chef debugging is enabled for compilation, print the whole Chef node as JSON
log 'Log the Chef `node` for debugging during compilation' do
  message "[#{recipe_name}] Compilation - `node`:  #{node.to_json}"
  level   :info
  only_if { node['mm']['common']['debug_chef']['compilation'] == true }
  action  :nothing

# Execute this resource during the compile phase instead of during convergence
end.run_action( :write )


# If Chef debugging is enabled for convergence, print the whole Chef node as JSON
log 'Log the Chef `node` for debugging during convergence' do
  message "[#{recipe_name}] Convergence - `node`:  #{node.to_json}"
  level   :info
  only_if { node['mm']['common']['debug_chef']['convergence'] == true }
  action  :write
end
