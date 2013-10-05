Puppet::Type.newtype(:freebox_ddns_client) do
  desc 'Type to manage Freebox DynDNS client configuration'

  newparam(:name) do
    desc 'Name of the DynDNS service provider.'
    newvalues(:ovh, :dyndns, :noip)
  end

  newproperty(:enabled) do
    desc 'Is the service enabled.'
  end

  newproperty(:hostname) do
    desc 'dns name to use to register.'
  end

  newproperty(:password) do
    desc 'password to use to register.'
  end

  newproperty(:user) do
    desc 'username to use to register.'
  end

end
