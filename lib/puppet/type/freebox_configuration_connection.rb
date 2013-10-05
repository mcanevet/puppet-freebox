Puppet::Type.newtype(:freebox_configuration_connection) do
  desc "Type to manage Freebox Connection Configuration"

  newparam(:name) do
  end

  newproperty(:params) do
    desc 'A hash containing the service configuration'
    isrequired

    munge do |value|
      value.reject{|k,v| v == :undef}
    end

    def insync?(is)
      (@should[0].to_a - is.to_a).empty?
    end
  end

end
