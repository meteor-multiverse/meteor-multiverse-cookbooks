node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping \"mm_layer_ssh::app_start\" for app \"#{application}\" as it is not a Node.js app")
    next
  end

  ruby_block "Start the Node.js app \"#{application}\"" do
    block do
      # Note that these 'monit' commands will actually NEVER fail unless the
      # deploy user does not have permissions to access to 'monit' itself, so
      # the $? (exit status) check afterward is basically useless. =(
      Chef::Log.info("Start Node.js via: #{deploy[:nodejs][:start_command]}")
      Chef::Log.info(`#{deploy[:nodejs][:start_command]}`)
      $? == 0
    end
  end

end
