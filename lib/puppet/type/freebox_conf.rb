Puppet::Type.newtype(:freebox_conf) do
  desc 'Type to manage freebox configuration'

  newparam(:name) do
    desc 'The Service to configure'
  end

  newproperty(:params) do
    desc 'The params of the service'
    isrequired

    munge do |value|
      value.reject{|k,v| v == :undef}
    end

    def insync?(is)
      (@should[0].to_a - is.to_a).empty?
    end
  end

end
