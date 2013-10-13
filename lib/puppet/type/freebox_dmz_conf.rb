Puppet::Type.newtype(:freebox_dmz_conf) do
  desc 'Type to manage Freebox DMZ configuration'

  newparam(:name) do
    desc 'The Freebox DMZ parameter to manage.'
    newvalues(:ip, :enabled)
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    munge do |value|
      case resource[:name]
      when :enabled
        case value
        when true, :true, 'true', 'yes', 'on'
          :true
        when false, :false, 'false', 'no', 'off'
          :false
        else
          fail("#{resource[:name]} MUST be a boolean (#{value}).")
        end
      else
        value
      end
    end
  end

end

