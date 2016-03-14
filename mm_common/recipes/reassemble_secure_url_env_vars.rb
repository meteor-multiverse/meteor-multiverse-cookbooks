################################################################################
#
# SUGGESTED USE:
#
# Include this recipe in ALL of the following AWS OpsWorks Lifecycle Phases:
#  - Setup
#  - Configure
#  - Deploy
#  - Undeploy
#  - Shutdown
#
################################################################################


# Default environment variable name
node.default['mm']['common']['secure_url_env_vars_reassembly_key'] = 'SECURE_URL_ENV_VARS_TO_REASSEMBLE'


# Reassemble split URL environment variables during the compile phase
ruby_block 'Reassemble split secure URL environment variables' do
  block do
    node['deploy'].each do |app, deploy|

      # NOTE:
      # This is the deserialization of multi-part URL environment variables for security.
      # The serialization occurs during stack creation in "meteor-multiverse-manager/lib/tasks/config.js".

      # Local variable
      reassembly_key = node['mm']['common']['secure_url_env_vars_reassembly_key']

      keys_to_reassemble_json = deploy['environment'][reassembly_key] || 'null'
      keys_to_reassemble = JSON.parse(keys_to_reassemble_json, { :quirks_mode => true })

      if !keys_to_reassemble.nil? && keys_to_reassemble.respond_to?('each')

        keys_to_reassemble.each do |url_env_var_key|
          protocol = deploy['environment'][url_env_var_key + '_PROTOCOL'] || ''
          user     = deploy['environment'][url_env_var_key + '_USER']     || ''
          password = deploy['environment'][url_env_var_key + '_PASSWORD'] || ''
          path     = deploy['environment'][url_env_var_key + '_PATH']     || ''

          if ( !user.empty? && !password.empty? && !path.empty? )

            # Create the actual intended environment variable
            node.default['deploy'][app]['environment'][url_env_var_key] = "#{protocol}//#{user}:#{password}@#{path}"

            # Override the "temporary" values with empty strings (`nil` will not work) to "hide" them
            node.normal['deploy'][app]['environment'][url_env_var_key + '_PROTOCOL'] = ''
            node.normal['deploy'][app]['environment'][url_env_var_key + '_USER']     = ''
            node.normal['deploy'][app]['environment'][url_env_var_key + '_PASSWORD'] = ''
            node.normal['deploy'][app]['environment'][url_env_var_key + '_PATH']     = ''
          end
        end

        # Override the serialization list key's value with an empty string (`nil` will not work) to "hide" it
        node.normal['deploy'][app]['environment'][reassembly_key] = ''

      end
    end
  end

  action :nothing

# Execute this resource during the compile phase instead of during convergence
end.run_action( :run )
