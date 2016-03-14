# If Chef debugging is enabled for compilation, print the whole Chef node as JSON
Chef::Log.info( "[#{cookbook_name}::#{recipe_name}] Compilation - `node`:  #{node.to_json}" )


ruby_block 'Log the Chef `data_bag`s' do
  block do

    # If Chef debugging is enabled for convergence, print the whole Chef node as JSON
    Chef::Log.info( "[#{cookbook_name}::#{recipe_name}] Convergence - `node`:  #{node.to_json}" )

    # Chef debugging of AWS OpsWorks data bags
    data_bag_names = [ 'aws_opsworks_app', 'aws_opsworks_command', 'aws_opsworks_ecs_cluster', 'aws_opsworks_elastic_load_balancer', 'aws_opsworks_instance', 'aws_opsworks_layer', 'aws_opsworks_rds_db_instance', 'aws_opsworks_stack', 'aws_opsworks_user' ]
    data_bag_names.each do |dbn|
      data_bag(dbn).each do |dbin|
        dbi = data_bag_item(dbn, dbin)
        Chef::Log.info( "[#{cookbook_name}::#{recipe_name}] `data_bag_item('#{dbn}', '#{dbin}')`:  #{dbi.to_json}" )
      end
    end

  end
end
