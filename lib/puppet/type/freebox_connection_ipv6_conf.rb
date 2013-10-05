Puppet::Type.newtype(:freebox_connection_ipv6_conf) do
  desc 'Type to manage Freebox IPv6 Connection'

  newparam(:name) do
    desc 'The Freebox IPv6 Connection parameter to manage.'
    newvalues(:ipv6_enabled, :delegations)
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    munge do |value|
      case resource[:name]
      when :ipv6_enabled
        case value
        when true, :true, 'true', 'yes', 'on'
          :true
        when false, :false, 'false', 'no', 'off'
          :false
        else
          fail("#{resource[:name]} MUST be a boolean (#{value}).")
        end
      when :delegations
        value
      else
        fail("Unknown parameter #{resource[:name]}.")
      end
    end
  end

end

