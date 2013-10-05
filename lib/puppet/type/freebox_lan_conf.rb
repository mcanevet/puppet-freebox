Puppet::Type.newtype(:freebox_lan_conf) do
  desc 'Type to manage Freebox Lan'

  newparam(:name) do
    desc 'The Freebox Lan parameter to manage.'
    newvalues(:ip, :server_name, :name_dns, :name_mdns, :name_netbios, :mode)
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    validate do |value|
      unless resource[:name] != :mode || (%w[router bridge].include? value)
        fail("Invalid mode #{value}.")
      end
    end
  end

end

