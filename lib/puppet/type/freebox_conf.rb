Puppet::Type.newtype(:freebox_conf) do
  desc "Type to manage freebox configuration"

  newparam(:name) do
    desc "The API url"
  end

  newparam(:app_token) do
    desc "The app_token to use"
  end

  newproperty(:request) do
    desc "The request to use for the API"
    isrequired
  end

end
