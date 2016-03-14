###
# By default, attempt to retrieve all cookbooks [without additional path info
# provided] from Chef's Supermarket
###
source 'https://supermarket.chef.io'
# source 'http://cookbooks.opscode.com/api/v1/cookbooks'
# source 'https://api.berkshelf.com'


###
# Tell Berkshelf how to package all of the sub-directory cookbooks
###
Dir.chdir(File.dirname(__FILE__)) do
  Dir.glob('./*').each do |path|
    if Dir.exist?(path) then
      cookbook File.basename(path), path: path
    end
  end
end
