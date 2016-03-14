name             'mm_layer_nodejs'
description      'Recipes for configuring the Node.js App Servers within a Meteor Multiverse stack'
maintainer       'James M. Greene'
maintainer_email 'james.m.greene@gmail.com'
license          'MIT'
version          '1.0.0'



###
# Note the official AWS OpsWorks cookbooks that are dependencies
###

#depends 'deploy'


###
# Note the unofficial sibling Meteor Multiverse cookbooks that are dependencies
###

depends 'mm_common'


###
# Note the non-AWS open source cookbooks that are dependencies
###

depends 'nodejs', '~> 2.4.4'
