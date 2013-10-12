Puppet::Type.newtype(:freebox_ftp_conf) do
  desc 'Type to manage Freebox FTP Server'

  newparam(:name) do
    desc 'The Freebox FTP parameter to manage.'
    newvalues(:enabled, :allow_anonymous, :allow_anonymous_write, :password)
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    munge do |value|
      case resource[:name]
      when :enabled, :allow_anonymous, :allow_anonymous_write
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
