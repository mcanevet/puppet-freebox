Puppet::Type.newtype(:freebox_conf) do
  desc "Type to manage freebox configuration"

  newparam(:name) do
    desc "The API url"
  end

  newparam(:session_token) do
    desc "The session_token to use"
  end

  newproperty(:request) do
    desc "The request to use for the API"
    isrequired

    munge do |value|
      value.reject{|k,v| v == :undef}
    end

    def insync?(is)
      (@should[0].to_a - is.to_a).empty?
    end
  end

end
