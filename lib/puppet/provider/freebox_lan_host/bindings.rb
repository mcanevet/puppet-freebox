begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning "You need freebox_api gem to manage Freebox OS with this provider."
end

Puppet::Type.type(:freebox_lan_host).provide(:bindings) do

  def self.app_token
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    section['app_token']
  end

  def self.lan_hosts
    mySession = FreeboxApi::Session.new(
      {:app_id => 'fr.freebox.puppet', :app_token => app_token},
      FreeboxApi::Freebox.new)

    FreeboxApi::Resources::LanHost.new(mySession)
  end

  def self.instances
    lan_hosts.index.collect { |lan_host|
      new(
        :name         => lan_host['id'],
        :ensure       => :present,
        :primary_name => lan_host['primary_name'],
        :host_type    => lan_host['host_type'],
        :persistent   => lan_host['persistent'],
      )
    }
  end

  def self.prefetch(resources)
    lan_hosts = instances
    resources.keys.each do |name|
      if provider = lan_hosts.find{ |lan_host| lan_host.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    myHash = {}
    myHash[:id] = resource[:name]
    (myHash[:primary_name] = resource[:primary_name]) if resource[:primary_name]
    (myHash[:host_type] = resource[:host_type]) if resource[:host_type]
    (myHash[:persistent] = resource[:persistent]) if resource[:persistent]
    self.class.lan_hosts.create(myHash)

    @property_hash[:ensure] = :present
  end

  def destroy
    self.class.lan_hosts.destroy(resource[:name])
    @property_hash.clear
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def flush
    myHash = {}
    if @property_flush
      (myHash[:primary_name] = resource[:primary_name]) if @property_flush[:primary_name]
      (myHash[:host_type] = resource[:host_type]) if @property_flush[:host_type]
      (myHash[:persistent] = resource[:persistent]) if @property_flush[:persistent]
      unless myHash.empty?
        myHash[:id] = resource[:name]
        self.class.lan_hosts.update(myHash)
      end
    end
    @property_hash = resource.to_hash
  end

  mk_resource_methods

end
