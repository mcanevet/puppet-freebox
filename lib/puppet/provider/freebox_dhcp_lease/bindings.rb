begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning "You need freebox_api gem to manage Freebox OS with this provider."
end

Puppet::Type.type(:freebox_dhcp_lease).provide(:bindings) do

  def self.app_token
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    section['app_token']
  end

  def self.instances
    FreeboxApi::Resources::DhcpLease.instances('fr.freebox.puppet', self.app_token).collect do |dhcp_lease|
      # initialize @property_hash
      new(
        :name     => dhcp_lease.id,
        :ensure   => :present,
        :mac      => dhcp_lease.mac,
        :comment  => dhcp_lease.comment,
        :hostname => dhcp_lease.hostname,
        :ip       => dhcp_lease.ip
      )
    end
  end

  def self.prefetch(resources)
    dhcp_leases = instances
    resources.keys.each do |name|
      if provider = dhcp_leases.find{ |dhcp_lease| dhcp_lease.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    # TODO
  end

  def destroy
    # TODO
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def mac
    @property_hash[:mac]
  end

  def mac=(value)
    @property_flush[:mac] = value
  end

  def comment
    @property_hash[:comment]
  end

  def comment=(value)
    @property_flush[:comment] = value
  end

  def hostname
    @property_hash[:hostname]
  end

  def hostname=(value)
    @property_flush[:hostname] = value
  end

  def ip
    @property_hash[:ip]
  end

  def ip=(value)
    @property_flush[:ip] = value
  end

  def flush
    # TODO
  end

end
