begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning 'You need freebox_api gem to manage Freebox OS with this provider.'
end

Puppet::Type.type(:freebox_ddns_client).provide(:bindings) do

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
    [
      FreeboxApi::Configuration::Connection::DDNS.getConfig(session, 'ovh').merge({:name => 'ovh'}),
      FreeboxApi::Configuration::Connection::DDNS.getConfig(session, 'dyndns').merge({:name => 'dyndns'}),
      FreeboxApi::Configuration::Connection::DDNS.getConfig(session, 'noip').merge({:name => 'noip'}),
    ].collect { |ddns|
      new(
        :name     => ddns[:name],
        :enabled  => :"#{ddns['enabled']}",
        :hostname => ddns['hostname'],
        :password => ddns['password'],
        :user     => ddns['user'],
      )
    }
  end

  def self.prefetch(resources)
    ddns_clients = instances
    resources.keys.each do |name|
      if provider = ddns_clients.find{ |ddns| ddns.name == name }
        resources[name].provider = provider
      end
    end
  end

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def enabled=(value)
    @property_flush[:enabled] = value
  end

  def hostname=(value)
    @property_flush[:hostname] = value
  end

  def password=(value)
    @property_flush[:password] = value
  end

  def user=(value)
    @property_flush[:user] = value
  end

  def flush
    myHash = {}
    if @property_flush
      (myHash[:enabled] = resource['enabled']) if @property_flush[:enabled]
      (myHash[:hostname] = resource['hostname']) if @property_flush[:hostname]
      (myHash[:password] = resource['password']) if @property_flush[:password]
      (myHash[:user] = resource['user']) if @property_flush[:user]
      puts "myHash=#{myHash}"
      unless myHash.empty?
        FreeboxApi::Configuration::Connection::DDNS.updateConfig(
          self.class.session, resource[:name], myHash)
      end
    end
    @property_hash = resource.to_hash
  end

end
