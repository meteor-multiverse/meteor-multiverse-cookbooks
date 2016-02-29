###
# By default, attempt to retrieve all cookbooks [without additional path info
# provided] from Chef's Supermarket
###
source 'https://supermarket.chef.io'
# source 'http://cookbooks.opscode.com/api/v1/cookbooks'
# source 'https://api.berkshelf.com'


# Global variables
$_aws_evaled = []
$ON_AMAZON = false
$AWS_OPSWORKS_COOKBOOK_DIR = '/opt/aws/opsworks/current/cookbooks'
$AWS_LOCAL_COOKBOOK_DIR = 'aws-cookbooks'
$AWS_COOKBOOK_BRANCH = 'release-chef-11.10'


###
# Simple wrapper for outputting debug messages
###
def debugLog(msg)
  #puts msg
  #STDOUT.puts msg
  STDERR.puts msg
end


###
# Assess whether Berks is running on an Amazon EC2 instance
###
require 'rbconfig'
$ON_AMAZON = (
  (RbConfig::CONFIG['host_os'] =~ /linux/i) != nil &&
  (
    RbConfig::CONFIG['target_vendor'] == 'amazon' ||
    (
      RbConfig::CONFIG['target_vendor'] == 'unknown' &&
      (`uname -r` =~ /\.amzn1\./i) != nil
    )
  )
)


debugLog("On Amazon? --> #{$ON_AMAZON}")
if $ON_AMAZON == false
  debugLog("`RbConfig::CONFIG['host_os']`                      --> #{(RbConfig::CONFIG['host_os']).to_json}")
  debugLog("`RbConfig::CONFIG['host_os'] =~ /linux/i`          --> #{(RbConfig::CONFIG['host_os'] =~ /linux/i).to_json}")
  debugLog("`(RbConfig::CONFIG['host_os'] =~ /linux/i) != nil` --> #{((RbConfig::CONFIG['host_os'] =~ /linux/i) != nil).to_json}")
  debugLog("`RbConfig::CONFIG['target_vendor']`                --> #{(RbConfig::CONFIG['target_vendor']).to_json}")
  debugLog("`RbConfig::CONFIG['target_vendor'] == 'amazon'`    --> #{(RbConfig::CONFIG['target_vendor'] == 'amazon').to_json}")
  debugLog("`RbConfig::CONFIG['target_vendor'] == 'unknown'`   --> #{(RbConfig::CONFIG['target_vendor'] == 'unknown').to_json}")
  debugLog("`\\`uname -r\\``                                   --> #{(`uname -r`).to_json}")
  debugLog("`\\`uname -r\\` =~ /\\.amzn1\\./i`                 --> #{(`uname -r` =~ /\.amzn1\./i).to_json}")
  debugLog("`(\\`uname -r\\` =~ /\\.amzn1\\./i) != nil`        --> #{((`uname -r` =~ /\.amzn1\./i) != nil).to_json}")
end


def download_opsworks_cookbooks()
  unless File.directory?($AWS_LOCAL_COOKBOOK_DIR)
    `git clone git@github.com:aws/opsworks-cookbooks.git --branch #{$AWS_COOKBOOK_BRANCH} --single-branch --depth 1 #{$AWS_LOCAL_COOKBOOK_DIR}`
  end
end


###
# Extension method derived from:
#   https://sethvargo.com/using-amazon-opsworks-with-berkshelf/
###
def opsworks_cookbook(name, version = '>= 0.0.0', options = {})
  debugLog("opsworks_cookbook(#{name}, #{version}, #{options})")

  if $ON_AMAZON
    debugLog(' -> Running on Amazon, so this cookbook should already be present!')

    # Check the on-Amazon unmerged root path for built-in OpsWorks cookbooks
    # More info on OpsWorks cookbook paths:
    #   http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-chef11-10.html
    unless File.directory?("#{$AWS_OPSWORKS_COOKBOOK_DIR}/#{name}")
      debugLog(
        " -> ERROR! OpsWorks cookbook '#{name}' could not be found at its expected path:\n" +
        "      #{$AWS_OPSWORKS_COOKBOOK_DIR}/#{name}\n"
      )
    end
  else
#    cookbook name, version, {
#      github: 'aws/opsworks-cookbooks',
#      branch: $AWS_COOKBOOK_BRANCH,
#      rel:    name
#    }.merge(options)

    download_opsworks_cookbooks()
    opsworks_local_cookbook("#{$AWS_LOCAL_COOKBOOK_DIR}/#{name}")
  end
end


def opsworks_local_cookbook(path)
  # Verify that the path is an existing directory
  if File.directory? path

    # Verify that each cookbook has a 'metadata.rb' file in its root directory
    if File.file? File.join(path, 'metadata.rb')

      name = File.basename(path)
      line = "opsworks_cookbook '#{name}'"
      if $_aws_evaled.index(line).nil?
        debugLog("Registering: `#{line}`")
        $_aws_evaled.push(line)

        # Register this sub-cookbook
        cookbook name, :path => File.absolute_path(path)
      end
    end
  end
end


def register_all_opsworks_cookbooks()
  download_opsworks_cookbooks()

  ###
  # Install all sub-directory cookbooks
  ###
  Dir.chdir(File.join(File.dirname(__FILE__), $AWS_LOCAL_COOKBOOK_DIR)) do
    Dir.glob('./*').each do |path|
      # Register this local AWS OpsWorks cookbook
      opsworks_local_cookbook(path)
    end
  end
end


###
# If not running on AWS, install all AWS OpsWorks Cookbooks to resolve dependencies
###
if $ON_AMAZON == false
  register_all_opsworks_cookbooks()
end



# MOAR Global variables!!1!
$_berks_evaled = []

###
# Extension method derived from:
#   http://steve-jansen.github.io/blog/2014/05/06/including-another-berksfile-in-your-berksfile/
#   https://sethvargo.com/berksfile-magic/
###
def sub_cookbook_dependencies(path)
  if (
    # Verify that the path is an existing directory
    File.directory?(path) &&
    # Verify that each cookbook has a 'metadata.rb' file in its root directory
    File.file?(File.join(path, 'metadata.rb')) &&
    # Verify that each cookbook has a 'Berksfile' file in its root directory
    File.file?(File.join(path, 'Berksfile.in'))
  )
    # Load all dependencies of this sub-cookbook from its own Berksfile, if any
    contents = File.read(File.join(path, 'Berksfile.in'))

    # Ignore lines like `site :blah` and `metadata`, which cannot be present multiple times
    contents = contents.gsub(/(^\s*site\s.*$)/, '')
    contents = contents.gsub(/(^\s*metadata(\s.*|)$)/, '')

    # Ignore comment lines and empty lines
    contents = contents.gsub(/(^\s*#.*$)/, '')
    contents = contents.gsub(/(^\s*$)/, '')

    contents.split(/\n/).select { |line| !(line.nil? || line.strip.empty?) }.each do |line|
      if $_berks_evaled.index(line).nil?
        debugLog("Running eval: `#{line}`")
        $_berks_evaled.push(line)

        instance_eval(line)
      else
        debugLog("Skipping duplicate eval: `#{line}`")
      end
    end
  end
end


###
# Install all sub-directory cookbooks
###
Dir.chdir(File.dirname(__FILE__)) do
  Dir.glob('./*').each do |path|
    sub_cookbook_dependencies path
  end
end
