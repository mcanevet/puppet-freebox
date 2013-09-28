Puppet::Type.newtype(:freebox_static_lease) do
  desc "Type to manage Freebox DHCP static leases"

  ensurable

  newparam(:name) do
    desc "DHCP static lease object id"
    munge do |value|
      value.upcase
    end
  end

  newproperty(:mac) do
    desc "Host mac address"
    munge do |value|
      value.upcase
    end
  end

  newproperty(:comment) do
    desc "an optional comment"
  end

  newproperty(:ip) do
    desc "IPv4 to assign to the host"
  end

end
