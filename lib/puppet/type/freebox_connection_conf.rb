Puppet::Type.newtype(:freebox_connection_conf) do
  desc 'Type to manage Freebox Connection'

  newparam(:name) do
    desc 'The Freebox Connection parameter to manage.'
    newvalues(:ping, :remote_access, :remote_access_port, :wol, :adblock, :allow_token_request)
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    munge do |value|
      case resource[:name]
      when :ping, :remote_access, :wol, :adblock, :allow_token_request
        case value
        when true, :true, 'true', 'yes', 'on'
          :true
        when false, :false, 'false', 'no', 'off'
          :false
        else
          fail("#{resource[:name]} MUST be a boolean (#{value}).")
        end
      when :remote_access_port
        Integer(value)
      else
        fail("Unknown parameter #{resource[:name]}.")
      end
    end
  end

end
