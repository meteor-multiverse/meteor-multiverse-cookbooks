# meteor-multiverse-cookbooks

Custom [Chef][] Cookbooks for Amazon [AWS OpsWorks][] to support [Meteor Multiverse][]



## The Cookbooks

### Cookbook: `common_layer`

This cookbook is for customizing any/all built-in or Custom Layer(s) within an OpsWorks Stack. It should **NOT** be considered a "Layer" of its own but rather a set of Layer customizations/enhancements that can be applied to any other Layer.

#### Purpose

This "Layer" provides:

 - A mechanism to apply shared best practices to any other Layer

#### Layer Necessity

 - Optional but recommended

#### Prerequisites

 - _N/A_

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `common_layer::setup`
 - **Configure**
     - `common_layer::configure`
 - **Deploy**
     - `common_layer::deploy`
 - **Undeploy**
     - `common_layer::undeploy`
 - **Shutdown**
     - `common_layer::shutdown`


#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - _N/A_



### Cookbook: `haproxy_layer`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to run an [HAProxy][] Load Balancer in front of [`nodejs_layer`][] and [`nginx_layer`][] Layers.

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
     - `haproxy_layer::setup`
 - **Configure**
     - `haproxy_layer::configure`
 - **Deploy**
     - `haproxy_layer::deploy`
 - **Undeploy**
     - `haproxy_layer::undeploy`
 - **Shutdown**
     - `haproxy_layer::shutdown`


#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - `haproxy_layer::app_restart`
     - Restart the HAProxy service
 - `haproxy_layer::app_start`
     - Start the HAProxy service
 - `haproxy_layer::app_stop`
     - Stop the HAProxy service




### Cookbook: `nginx_layer`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to host/serve the static frontend assets from a [Meteor][] app bundle using [NGINX][] web server(s). Those same static frontend assets are available in the [`nodejs_layer`][] as well, just in case this `nginx_layer` is unavailable (or you choose not to enable this layer).

#### Purpose

This Layer provides:

 - Serving frontend static assets to offload that mindless burden from the [`nodejs_layer`][]
 - GZip compression of those assets for reduced download size/time

#### Layer Necessity

 - Optional but recommended

#### Prerequisites

 1. You must use a Custom Layer.
 2. Your App's type must be specifically set to `Node.js`.
 3. Your App's source origin must contain the _**unzipped**_ contents of the ZIP file produced by running `meteor bundle bundle.tgz` on your Meteor app codebase.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `nginx_layer::setup`
 - **Configure**
     - `nginx_layer::configure`
 - **Deploy**
     - `nginx_layer::deploy`
 - **Undeploy**
     - `nginx_layer::undeploy`
 - **Shutdown**
     - `nginx_layer::shutdown`


#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - `nginx_layer::app_restart`
     - Restart the NGINX service
 - `nginx_layer::app_start`
     - Start the NGINX service
 - `nginx_layer::app_stop`
     - Stop the NGINX service




### Cookbook: `nodejs_layer`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to run a [Meteor][] app bundle using [Node.js][] &mdash; _NOT_ using [Meteor][]!

#### Purpose

This Layer provides:

 - ???

#### Layer Necessity

 - _**REQUIRED!**_

#### Prerequisites

 1. You must use a Custom Layer.
 2. Your App's type must be specifically set to `Node.js`.
 3. Your App's source origin must contain the _**unzipped**_ contents of the ZIP file produced by running `meteor bundle bundle.tgz` on your Meteor app codebase.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `nodejs_layer::setup`
 - **Configure**
     - `nodejs_layer::configure`
 - **Deploy**
     - `nodejs_layer::deploy`
 - **Undeploy**
     - `nodejs_layer::undeploy`
 - **Shutdown**
     - `nodejs_layer::shutdown`


#### Recipe Usage outside of the AWS OpsWorks Lifecycle Phases

 - `nodejs_layer::app_restart`
     - Restart the Node.js app process(es)
 - `nodejs_layer::app_start`
     - Start the Node.js app process(es)
 - `nodejs_layer::app_stop`
     - Stop the Node.js app process(es)



### Cookbook: `ssh_layer`

This cookbook is for customizing a Custom Layer in an OpsWorks Stack to serve as your secured SSH Bastion Host a.k.a. SSH Jump Host a.k.a. SSH Pass-Through.  In other words, if you enable this layer, then you must always SSH tunnel into one of its SSH Bastion Host servers before continuing on to one of the servers from the other Layers.

You can also choose to create this Layer in a separate OpsWorks Stack all of its own and then establish a [VPC Peering Connection][] between it and your others OpsWorks Stacks using a ["Hub-and-Spoke" Configuration][] to establish a one-to-many relationship of SSH Bastion Hosts to all of your other servers.

#### Purpose

This Layer provides:

 - Security buffer against unauthorized shell access

#### Layer Necessity

 - Optional but recommended

#### Prerequisites

 1. You must use a Custom Layer.

#### Recipe Usage per AWS OpsWorks Lifecycle Phase

 - **Setup**
     - `ssh_layer::setup`
 - **Configure**
     - `ssh_layer::configure`
 - **Deploy**
     - `ssh_layer::deploy`
 - **Undeploy**
     - `ssh_layer::undeploy`
 - **Shutdown**
     - `ssh_layer::shutdown`


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
[`common_layer`]: #cookbook-common_layer
[`haproxy_layer`]: #cookbook-haproxy_layer
[`nginx_layer`]: #cookbook-nginx_layer
[`nodejs_layer`]: #cookbook-nodejs_layer
[`ssh_layer`]: #cookbook-ssh_layer
[VPC Peering Connection]: http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/vpc-peering-overview.html
["Hub-and-Spoke" Configuration]: http://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/peering-configurations-full-access.html#one-to-many-vpcs-full-access
