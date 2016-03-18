# meteor-multiverse-cookbooks

Custom [Chef][] Cookbooks for Amazon [AWS OpsWorks][] to support [Meteor Multiverse][] environments



## The Cookbooks

### Cookbook: `mm_layer_haproxy`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to run an [HAProxy][] Load Balancer in front of [`mm_layer_nodejs`][] and [`mm_layer_nginx`][] Layers.

#### Purpose

This Layer provides:

 - Force HTTPS
 - HTTPS termination
 - Load balancing
 - Sticky sessions via server affinity
 - High-level backend server statistics and administration dashboards

#### Layer Necessity

 - _**REQUIRED!**_

#### Prerequisites

 1. You must use a Custom Layer.
 2. Your App's type must be specifically set to `Node.js`.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `mm_layer_haproxy::setup`
 - **Configure**
     - `mm_layer_haproxy::configure`
 - **Deploy**
     - `mm_layer_haproxy::deploy`
 - **Undeploy**
     - `mm_layer_haproxy::undeploy`
 - **Shutdown**
     - `mm_layer_haproxy::shutdown`

#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - `mm_layer_haproxy::app_restart`
     - Restart the HAProxy service
 - `mm_layer_haproxy::app_start`
     - Start the HAProxy service
 - `mm_layer_haproxy::app_stop`
     - Stop the HAProxy service




### Cookbook: `mm_layer_nginx`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to host/serve the static frontend assets from a [Meteor][] app bundle using [NGINX][] web server(s). Those same static frontend assets are available in the [`mm_layer_nodejs`][] as well, just in case this `mm_layer_nginx` is unavailable (or you choose not to enable this layer).

#### Purpose

This Layer provides:

 - Serving frontend static assets to offload that mindless burden from the [`mm_layer_nodejs`][]
 - GZip compression of those assets for reduced download size/time

#### Layer Necessity

 - Optional but recommended

#### Prerequisites

 1. You must use a Custom Layer.
 2. Your App's type must be specifically set to `Node.js`.
 3. Your App's source origin must contain the _**unzipped**_ contents of the ZIP file produced by running `meteor bundle bundle.tgz` on your Meteor app codebase.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `mm_layer_nginx::setup`
 - **Configure**
     - `mm_layer_nginx::configure`
 - **Deploy**
     - `mm_layer_nginx::deploy`
 - **Undeploy**
     - `mm_layer_nginx::undeploy`
 - **Shutdown**
     - `mm_layer_nginx::shutdown`

#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - `mm_layer_nginx::app_restart`
     - Restart the NGINX service
 - `mm_layer_nginx::app_start`
     - Start the NGINX service
 - `mm_layer_nginx::app_stop`
     - Stop the NGINX service




### Cookbook: `mm_layer_nodejs`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to run a [Meteor][] app bundle using [Node.js][] &mdash; _NOT_ using Meteor!

#### Purpose

This Layer provides:

 - Serving the primary functionality of the [Meteor][] app from its bundled [Node.js][] app form

#### Layer Necessity

 - _**REQUIRED!**_

#### Prerequisites

 1. You must use a Custom Layer.
 2. Your App's type must be specifically set to `Node.js`.
 3. Your App's source origin must contain the _**unzipped**_ contents of the ZIP file produced by running `meteor bundle bundle.tgz` on your Meteor app codebase.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `mm_layer_nodejs::setup`
 - **Configure**
     - `mm_layer_nodejs::configure`
 - **Deploy**
     - `mm_layer_nodejs::deploy`
 - **Undeploy**
     - `mm_layer_nodejs::undeploy`
 - **Shutdown**
     - `mm_layer_nodejs::shutdown`

#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - `mm_layer_nodejs::app_restart`
     - Restart the Node.js app process(es)
 - `mm_layer_nodejs::app_start`
     - Start the Node.js app process(es)
 - `mm_layer_nodejs::app_stop`
     - Stop the Node.js app process(es)




### Cookbook: `mm_layer_ssh`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to serve as your secured SSH Bastion Host a.k.a. SSH Jump Host a.k.a. SSH Pass-Through.  In other words, if you enable this layer, then you must always SSH tunnel into one of its SSH Bastion Host servers before continuing on to one of the servers from the other Layers.

You can also choose to create this Layer in a separate OpsWorks Stack all of its own and then establish a [VPC Peering Connection][] between it and your others OpsWorks Stacks using a ["Hub-and-Spoke" Configuration][] to establish a one-to-many relationship of SSH Bastion Hosts to all of your other servers.

#### Purpose

This Layer provides:

 - Secure SSH tunneling for authorized shell access
 - Security buffer against unauthorized shell access

#### Layer Necessity

 - Optional but recommended

#### Prerequisites

 1. You must use a Custom Layer.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `mm_layer_ssh::setup`
 - **Configure**
     - `mm_layer_ssh::configure`
 - **Deploy**
     - `mm_layer_ssh::deploy`
 - **Undeploy**
     - `mm_layer_ssh::undeploy`
 - **Shutdown**
     - `mm_layer_ssh::shutdown`


#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - _N/A_




### Cookbook: `mm_lib_common`

???
This cookbook is for customizing any/all built-in or Custom Layer(s) within an OpsWorks Stack. It should **NOT** be considered a "Layer" of its own but rather a set of Layer customizations/enhancements that can be applied to any other Layer.
???

#### Purpose

???
This "Layer" provides:

 - A mechanism to apply shared best practices to any other Layer

#### Layer Necessity

 - Optional but recommended

#### Prerequisites

 - _N/A_

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `mm_lib_common::setup`
 - **Configure**
     - `mm_lib_common::configure`
 - **Deploy**
     - `mm_lib_common::deploy`
 - **Undeploy**
     - `mm_lib_common::undeploy`
 - **Shutdown**
     - `mm_lib_common::shutdown`

#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - _N/A_




## Creating New Cookbooks

See [CONTRIBUTING.md](CONTRIBUTING.md).


## Acknowledgements

Special thanks go out to:
 - The Amazon AWS team for open sourcing the core OpsWorks cookbooks: [aws/opsworks-cookbooks][]. This was a major help in understanding the [almost] complete internal flow of OpsWorks, as well as in eventually deciding to use all custom Layers instead of fighting against the built-in Layers.



<!--- RESOURCE LINKS -->

[Meteor Multiverse]: http://meteormultiverse.org/
[Chef]: https://www.chef.io/chef/
[AWS OpsWorks]: http://aws.amazon.com/opsworks/
[HAProxy]: http://www.haproxy.org/
[NGINX]: http://nginx.org/
[Meteor]: https://www.meteor.com/
[Node.js]: https://nodejs.org/
[aws/opsworks-cookbooks]: https://github.com/aws/opsworks-cookbooks/
[`mm_lib_common`]: #cookbook-mm_lib_common
[`mm_layer_haproxy`]: #cookbook-mm_layer_haproxy
[`mm_layer_nginx`]: #cookbook-mm_layer_nginx
[`mm_layer_nodejs`]: #cookbook-mm_layer_nodejs
[`mm_layer_ssh`]: #cookbook-mm_layer_ssh
[VPC Peering Connection]: http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/vpc-peering-overview.html
["Hub-and-Spoke" Configuration]: http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/peering-configurations-full-access.html#one-to-many-vpcs-full-access
