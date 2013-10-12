Puppet::Type.newtype(:freebox_dhcp_conf) do
  desc 'Type to manage Freebox DHCP Server'

  newparam(:name) do
    desc 'The Freebox Lan parameter to manage.'
    newvalues(:enabled, :sticky_assign, :ip_range_start, :ip_range_end, :always_broadcast, :dns)
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    munge do |value|
      case resource[:name]
      when :enabled, :sticky_assign, :always_broadcast
        case value
        when true, :true, 'true', 'yes', 'on'
          :true
        when false, :false, 'false', 'no', 'off'
          :false
        else
          fail("#{resource[:name]} MUST be a boolean (#{value}).")
        end
      when :ip_range_start, :ip_range_end, :dns
        value
      end
    end
  end

end


