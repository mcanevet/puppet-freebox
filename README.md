Freebox OS module
=================

WARNING: Work In Progress.

Overview
--------

The Freebox OS module allows you to easily manage the Freebox Server settings in Puppet via the FreeboxOS Gateway API.

Pre-requirement
---------------

First, you have to obtain an app_token. This procedure can only be initiated from the local network, and the user must have access to the Freebox front panel to grant access to the app.

    puppet apply -e 'notice(freebox_app_token("fr.freebox.puppet","Freebox Puppet","0.0.1","raspberry"))'

Then got to your Freebox OS interface (http://mafreebox.free.fr) to allow `Freebox Puppet` application to update Freebox settings (in "Paramètres de la Freebox" > "Gestion des accès" > "Applications").

Usage
-----

**Define app_token for all classes:**

Just declare the `freebox` class with `app_token` parameter:

    class { 'freebox':
      app_token => 'dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0',
    }

**Configure DHCP**

    class { 'freebox::dhcp':
      enabled        => true,
      ip_range_start => '192.168.0.10',
      ip_range_end   => '192.168.0.50',
    }

Reference
---------

Classes:

* [freebox](#class-freebox)
* [freebox::dhcp](#class-freeboxdhcp)

Resources:

* [freebox::dhcp::lease](#resource-freeboxdhcplease)

Functions:

* [freebox\_app\_token](#function-freeboxapptoken)
* [freebox\_session\_token](#function-freeboxsessiontoken)

Types:

* [freebox\_conf](#type-freeboxconf)
* [freebox\_dhcp\_lease](#type-freeboxdhcplease)

###Class: freebox
This class is used to set the main settings for this module, to be used by the other classes and defined resources. On its own it does nothing.

For example, if you want to override the default `app_id` you could use the following combination:

    class { 'freebox':
      app_token => 'dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0',
      app_id    => 'fr.freebox.puppetconf',
    }

That would make the `app_token`(mandatory) and `app_id` default for all classes and defined resources in this module.

####`app_token`
The app_token to use (see above to generate one).

####`app_id`
Override the default app_id (generated app_token must match the app_id). Defaults to `fr.freebox.puppet`.

####`app_name`
Override the default app_name. Defaults to `Freebox Puppet`.

####`app_version`
Override the app version.

####̀`device_name`
Override the device name. Defaults to `$::hostname`.

###Class: freebox::dhcp
This class is used to configure the DHCP server of the Freebox Server.

####̀ always_broadcast`
Always broadcast DHCP responses.

####`dns`
List of dns servers to include in DHCP reply.

####`enabled`
Enable/Disable the DHCP server.

####`gateway`
Gateway IP address.

####`ip_range_end`
DHCP range end IP.

####`ip_range_start`
DHCP range start IP.

####`netmask`
Gateway subnet netmask.

####`sticky_assign`
Always assign the same IP to a given host.

####`leases`
Hash containing leases to declare.

###Resource: freebox::dhcp::lease
This resource is used to declare a DHCP static lease.

####`ip`
IPv4 to assign to the host.

####`mac`
Host mac address. Defaults to `name`.

####`comment`
an optional comment.

####`hostname`
hostname matching the mac address.
