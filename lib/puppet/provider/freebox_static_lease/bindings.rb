begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning "You need freebox_api gem to manage Freebox OS with this provider."
end

Puppet::Type.type(:freebox_static_lease).provide(:bindings) do

  def self.app_token
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    section['app_token']
  end

  def self.static_leases
    mySession = FreeboxApi::Session.new(
      {:app_id => 'fr.freebox.puppet', :app_token => app_token},
      FreeboxApi::Freebox.new)

    FreeboxApi::Resources::StaticLease.new(mySession)
  end

  def self.instances
    static_leases.index.collect do |static_lease|
      new(
        :name     => static_lease['id'],
        :ensure   => :present,
        :mac      => static_lease['mac'],
        :comment  => static_lease['comment'],
        :ip       => static_lease['ip']
      )
    end
  end

  def self.prefetch(resources)
    static_leases = instances
    resources.keys.each do |name|
      if provider = static_leases.find{ |static_lease| static_lease.name == name }
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
    (myHash[:mac] = resource[:mac]) if resource[:mac]
    (myHash[:comment] = resource[:comment]) if resource[:comment]
    (myHash[:ip] = resource[:ip]) if resource[:ip]
    self.class.static_leases.create(myHash)

    @property_hash[:ensure] = :present
  end

  def destroy
    self.class.static_leases.destroy(resource[:name])
    @property_hash.clear
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def flush
    myHash = {}
    if @property_flush
      (myHash[:mac] = resource[:mac]) if @property_flush[:mac]
      (myHash[:comment] = resource[:comment]) if @property_flush[:comment]
      (myHash[:ip] = resource[:ip]) if @property_flush[:ip]
      unless myHash.empty?
        myHash[:id] = resource[:name]
	self.class.static_leases.update(myHash)
      end
    end
    @property_hash = resource.to_hash
  end

  mk_resource_methods

end
