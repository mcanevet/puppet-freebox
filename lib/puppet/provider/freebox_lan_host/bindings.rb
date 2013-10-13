begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning 'You need freebox_api gem to manage Freebox OS with this provider.'
end

Puppet::Type.type(:freebox_lan_host).provide(:bindings) do

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
    FreeboxApi::Configuration::Lan::Browser::Interface.getLanHosts(session, 'pub').collect do |lan_host|
      new(
        :name         => lan_host['id'],
        :ensure       => :present,
        :primary_name => lan_host['primary_name'],
        :host_type    => lan_host['host_type'],
        :persistent   => lan_host['persistent'],
      )
    end
  end

  def self.prefetch(resources)
    lan_hosts = instances
    resources.keys.each do |name|
      if provider = lan_hosts.find{ |lan_host| lan_host.name == name }
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

  def flush
    myHash = {}
    if @property_flush
      (myHash[:primary_name] = resource[:primary_name]) if @property_flush[:primary_name]
      (myHash[:host_type] = resource[:host_type]) if @property_flush[:host_type]
      (myHash[:persistent] = resource[:persistent]) if @property_flush[:persistent]
      unless myHash.empty?
        myHash[:id] = resource[:name]
        FreeboxApi::Configuration::Lan::Browser::LanHost.update(self.class.session, 'pub', resource[:name], myHash)
      end
    end
    @property_hash = resource.to_hash
  end

end
