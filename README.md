Freebox OS module
=================

[![Build Status](https://travis-ci.org/mcanevet/puppet-freebox.png?branch=master)](https://travis-ci.org/mcanevet/puppet-freebox)

WARNING: Work In Progress.

Overview
--------

The Freebox OS module allows you to easily manage the Freebox Server settings in Puppet via the FreeboxOS Gateway API.

Pre-requirement
---------------

First, you have to obtain an app_token. This procedure can only be initiated from the local network, and the user must have access to the Freebox front panel to grant access to the app.

```ruby
require 'freebox_api'

FreeboxApi::Freebox.new.authorize({
  :app_id      => 'fr.freebox.puppet',
  :app_name    => 'Freebox Puppet',
  :app_version => '0.0.1',
  :device_name => 'puppetmaster.example.com')
})['app_token']
```
or
```
curl -X POST http://mafreebox.free.fr/api/v1/login/authorize -H "Content-Type: application/json" -d '{"app_id" : "fr.freebox.puppet", "app_name" : "Freebox Puppet", "app_version" : "0.0.1", "puppetmaster.example.com"}'
```

Then got to your Freebox OS interface (http://mafreebox.free.fr) to allow `Freebox Puppet` application to update Freebox settings (in "Paramètres de la Freebox" > "Gestion des accès" > "Applications").

Usage
-----

**Create a node definition for every freebox to manage**

```puppet
node 'mafreebox.free.fr' {
  
  class { 'freebox':
    app_token => 'dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0',
  }

}

node 'mafreebox.example.com' {
  
  class { 'freebox':
    app_token => 'dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0',
  }

}
```

Then include the class of the module you want to manage:

```puppet
include ::freebox::configuration::connection
include ::freebox::configuration::connection::ipv6
include ::freebox::configuration::lan
...
```

I you want to remove all unmanaged resources for a certain type of resource you can do it like this:

```puppet
resources { 'freebox_static_lease': purge => true, }
```

**Run puppet**

With a puppetmaster

```
export FACTER_operatingsystem=FreeboxOS

export FACTER_clientcert=mafreebox.free.fr
puppet agent -t --certname=$FACTER_clientcert

export FACTER_clientcert=mafreebox.example.com
puppet agent -t --certname=$FACTER_clientcert
```

or in standalone mode

```
export FACTER_operatingsystem=FreeboxOS

export FACTER_clientcert=mafreebox.free.fr
puppet apply --certname=$FACTER_clientcert

export FACTER_clientcert=mafreebox.example.com
puppet apply --certname=$FACTER_clientcert
```

Overriding operatingsystem and setting clientcert fact is required so that other facts are overridden (like ipaddress).

Reference
---------

Classes:

* [freebox](#class-freebox)
* [freebox::configuration::connection](#class-freeboxconfigurationconnection)
* [freebox::configuration::connection::ipv6](#class-freeboxconfigurationconnectionipv6)
* [freebox::configuration::lan](#class-freeboxconfigurationlan)
* [freebox::configuration::dhcp](#class-freeboxconfigurationdhcp)
* [freebox::configuration::ftp](#class-freeboxconfigurationftp)
* [freebox::configuration::nat::dmz](#class-freeboxconfigurationnatdmz)

Resources:

* [freebox\_ddns\_client](#resource-freeboxddnsclient)
* [freebox\_static\_lease](#resource-freeboxstaticlease)
* [freebox\_lan\_host] (#resource-freeboxlanhost)

###Class: freebox
This class is used to set the main settings for this module, to be used by the other classes and defined resources.

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

####`device_name`
Override the device name. Defaults to `$::hostname`.

###Class: freebox::configuration::connection
This class is used to configure the Freebox IPv4 connection.

####`ping`
Should the Freebox respond to external ping requests.

####`remote_access`
Enable/disable HTTP remote access.

####`remote_access_port`
Port number to use for remote HTTP access.

####`wol`
Enable/disable Wake-on-lan proxy.

####`adblock`
Is ads blocking feature enabled.

####`allow_token_request`
If false, user has disabled new token request. New apps can’t request a new token. Apps that already have a token are still allowed.

####`ddns_client`
A hash containing DynDNS client configuration.

###Class: freebox::configuration::connection::ipv6
This class is used to configure the Freebox IPv6 connection.

####`enabled`
is IPv6 enabled.

####`delegations`
list of IPv6 delegations.

###Class: freebox::configuration::lan
This class is used to modify the Freebox Server network configuration.

####`ip`
Freebox Server IPv4 address.

####`server_name`
Freebox Server name.

####`name_dns`
Freebox Server DNS name.

####`name_mdns`
Freebox Server mDNS name.

####`name_netbios`
Freebox Server netbios name.

####`type`
The valid LAN modes are:
`router`: The Freebox acts as a network router.
`bridge`: The Freebox acts as a network bridge.
NOTE: in bridge mode, most of Freebox services are disabled. It is recommended to use the router mode.

###Class: freebox::configuration::dhcp
This class is used to configure the DHCP server of the Freebox Server.

####`always_broadcast`
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

###Class: freebox::configuration::ftp
This class is used to configure the FTP server of the Freebox Server.

####`enabled`
is the FTP server enabled.

####`allow_anonymous`
can anonymous user log in.

####`allow_anonymous_write`
can anonymous user write data.

####`password`
user password.

###Class: freebox::configuration::nat::dmz
This class is used to configure the DMZ of the Freebox Server.

####`ip`
dmz host IP.

####`enabled`
is dmz enabled.

###Resource: freebox\_ddns\_client
This resource is used to configure a DynDNS client.

####`name`
The name of the dynamic DNS provider. Right now the supported dynamic dns providers are:
* ovh
* dyndns
* noip

####`enabled`
Is this provider enabled.

####`hostname`
dns name to use to register.

####`password`
password to use to register.

####`user`
username to use to register.

###Resource: freebox\_static\_lease
This resource is used to declare a DHCP static lease.

####`ip`
IPv4 to assign to the host.

####`mac`
Host mac address. Defaults to `name`.

####`comment`
an optional comment.

###Resource: freebox\_lan\_host
This resource is used to modify host information.

####`primary_name`
Host primary name.

####`host_type`
When possible, the Freebox will try to guess the `host_type`, but you can manually override this to the correct value.
Possible values are:

source            | Description
------------------|-------------------
workstation       | Workstation
laptop            | Laptop
smartphone        | Smartphone
tablet            | Tablet
printer           | Printer
vg_console        | Video game console
television        | TV
nas               | Nas
ip_camera         | IP Camera
ip_phone          | IP Phone
freebox_player    | Freebox Player
freebox_hd        | Freebox Server
networking_device | Networking device
multimedia_device | Multimedia device
other             | Other

####`persistent`
If true the host is always shown even if it has not been active since the Freebox startup.
