# meteor-multiverse-cookbooks

Custom [Chef][] cookbooks (and recipes) for use in [AWS OpsWorks][].


## Understanding OpsWorks

Before you can start creating Chef Cookbooks for OpsWorks, it is very important
that you understand how OpsWorks Instance and App management works.


### OpsWorks Lifecycle Events

Before you can add Chef Cookbooks' recipes into OpsWorks Layer configurations,
you need to get familiar with the various trigger events imposed by the
OpsWorks lifecycle.


#### Setup

The "Setup" lifecycle event runs on a single instance after it finishes
booting. This is the best place to handle installing any main underlying
software (Node.js, Rails, etc.) on the instance.

At the end of the "Setup" lifecycle event, the ["Deploy" lifecycle event](#deploy) will also be run.

After the "Setup" and "Deploy" executions have both completed, the instance is
finally considered to be "online" in OpsWorks status terminology.

You can also trigger this event by manually running the "Setup" command against
a selectable set of online instances.


#### Configure

The "Configure" lifecycle event runs **across ALL instances** whenever any
single instance within the OpsWorks Stack is brought online (started) or taken
offline (stopped). This is critically useful for any Layer in which instances
need to be aware of other instances (e.g. HAProxy Load Balancers, SSH Bastion
Hosts, etc.) but not particularly useful for other normal Layers.

**TIP:** Leverage this event sparingly, if at all, as it will be executed
frequently in any OpsWorks Stacks with time-based or load-based auto-scaling
enabled.


#### Deploy

The "Deploy" lifecycle event runs on a set of instances (ALL online instances,
by default) after a new Deployment is created for an OpsWorks App _or_ after
the "Deploy" command is executed, typically to deploy an application to a setup
of application server instances. This should include all the recipes needed to
install and configure the application to reach the desired operational state.

Although I advise against the risk of putting too much into recipes for this
phase, it is also a great place to reconfigure any instance-wide settings you
may have concerns about remaining stable.

**NOTE:** This event is also included at the end of the ["Setup" lifecycle event](#setup).


#### Undeploy

The "Undeploy" lifecycle event occurs when you delete an OpsWorks App _or_ run
an "Undeploy" command to remove ALL versions of an application from a set of
instances (ALL online instances, by default) and perform any other required
cleanup to shutdown the app permanently and leave the server in a pristine
state.


#### Shutdown

The "Shutdown" lifecycle event occurs after you stop an OpsWorks instance (i.e.
tell it to shutdown) but _before_ the associated underlying EC2 instance is
actually terminated. This should include any instance-level cleanup tasks, such
as gracefully shutting down services, backing up logs, sending notifications,
etc.

By default, this period can last a maximum of 120 seconds. However, you can
configure that duration at the Layer level: valid values are `0`-`2700`
(seconds).



## Understanding Chef

[Chef][] is a ???. _Oh boy, here we go...._

### Attributes

???

### Recipes

???

### Berkshelf

???



## Creating New Chef Cookbooks for OpsWorks

### Cookbook Name

When creating a new Cookbook for OpsWorks, you should create a new top-level
directory and name it the same as your intended Cookbook name (e.g.
"haproxy_layer"). In order to avoid a headache later, you prefer underscores
(`_`) instead of dashes/hyphens (`-`) when naming your Cookbook.


### Cookbook Directory Layout

The following is our standard convention for the directory layout of OpsWorks
Chef Cookbooks:

```
opsworks-cookbooks
 ├── my_new_cookbook
 │    ├── attributes
 │    │    ├── default.rb
 │    │    ├── customize.rb
 │    │    └── ...
 │    ├── recipes
 │    │    ├── configure.rb
 │    │    ├── default.rb
 │    │    ├── deploy.rb
 │    │    ├── setup.rb
 │    │    ├── shutdown.rb
 │    │    └── undeploy.rb
 │    ├── templates              # Only needed if using Erubis file templates
 │    │    ├── default           # "default" == Chef Environment
 │    │    │    ├── my_temp.erb
 │    │    │    └── ...
 │    │    └── ...               # May have dirs for other Chef Environments
 │    ├── metadata.rb
 │    └── ...
 └── ...
```
