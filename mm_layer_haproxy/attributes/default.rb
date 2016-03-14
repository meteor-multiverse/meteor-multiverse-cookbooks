###
# Do NOT use this file to override this cookbook's default attributes.
# Instead, please use the "customize.rb" attributes file, which will keep
# your adjustments separate from the AWS OpsWorks codebase and make it
# easier to upgrade.
#
# However, you should not edit "customize.rb" directly. Instead, create a
# "{thisCookbookName}/attributes/customize.rb" file in your own cookbook
# repository and put the overrides in YOUR "customize.rb" file.
#
# Do NOT create an "{thisCookbookName}/attributes/default.rb" in your
# cookbooks. Doing so would completely override this file and might cause
# upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

default['mm']['layers']['haproxy']['foo'] = 'abc'

include_attribute 'mm_layer_haproxy::customize'
