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

Usage
-----

Just include the `freebox` class:

    include ::freebox

With the right (see above) freebox::app_token in your hiera configuration file:

    ---
    freebox::app_token: dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0
