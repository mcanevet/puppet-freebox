begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning 'You need freebox_api gem to manage Freebox OS with this provider.'
end

Puppet::Type.type(:freebox_static_lease).provide(:bindings) do

  def self.clientcert
    Facter['clientcert'] == nil ? 'mafreebox.free.fr' : Facter['clientcert'].value
  end

  def self.inisection
    IniFile.load('/etc/puppet/freebox.conf')[clientcert]
  end

  def self.app_id
    inisection['app_id']
  end

  def self.app_token
    inisection['app_token']
  end

  def self.port
    inisection['port']
  end

  def self.session
    FreeboxApi::Session.new(
      {:app_id => 'fr.freebox.puppet', :app_token => app_token},
      FreeboxApi::Freebox.new({
        :freebox_ip   => clientcert,
        :freebox_port => port,
      })
    )
  end

  def self.instances
    FreeboxApi::Configuration::Dhcp.static_leases(session).collect { |static_lease|
      new(
        :name     => static_lease['id'],
        :ensure   => :present,
        :mac      => static_lease['mac'],
        :comment  => static_lease['comment'],
        :ip       => static_lease['ip']
      )
    }
  end

  def self.prefetch(resources)
    static_leases = instances
    resources.keys.each do |name|
      if provider = static_leases.find{ |static_lease| static_lease.name == name }
        resources[name].provider = provider
      end
    end
  end

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    myHash = {}
    myHash[:id] = resource[:name]
    (myHash[:mac] = resource[:mac]) if resource[:mac]
    (myHash[:comment] = resource[:comment]) if resource[:comment]
    (myHash[:ip] = resource[:ip]) if resource[:ip]
    FreeboxApi::Configuration::Dhcp::StaticLease.create(self.class.session, myHash)

    @property_hash[:ensure] = :present
  end

  def destroy
    FreeboxApi::Configuration::Dhcp::StaticLease.delete(self.class.session, resource[:name])
    @property_hash.clear
  end

  def flush
    myHash = {}
    if @property_flush
      (myHash[:mac] = resource[:mac]) if @property_flush[:mac]
      (myHash[:comment] = resource[:comment]) if @property_flush[:comment]
      (myHash[:ip] = resource[:ip]) if @property_flush[:ip]
      unless myHash.empty?
        myHash[:id] = resource[:name]
        FreeboxApi::Configuration::Dhcp::StaticLease.update(self.class.session, myHash)
      end
    end
    @property_hash = resource.to_hash
  end

end
