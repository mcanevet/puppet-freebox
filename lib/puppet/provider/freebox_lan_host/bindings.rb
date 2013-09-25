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

  def self.instances
    mafreebox = FreeboxApi::Freebox.new(
      self.app_token,
      'fr.freebox.puppet',
      'Puppet Freebox',
      '0.1.0',
      'foo'
    )
    mafreebox.lan_hosts.collect do |lan_host|
      new(
        :name         => lan_host.id,
        :ensure       => :present,
        :primary_name => lan_host.primary_name,
        :host_type    => lan_host.host_type,
        :persistent   => lan_host.persistent,
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

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    puts 'Not implemented yet'
  end

  def destroy
    puts 'Not implemented yet'
  end

  def flush
    puts 'Not implemented yet'
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def primary_name
    @property_hash[:primary_name]
  end

  def primary_name=(value)
    @property_flush[:primary_name] = value
  end

  def host_type
    @property_hash[:host_type]
  end

  def host_type=(value)
    @property_flush[:host_type] = value
  end

  def persistent
    @property_hash[:persistent]
  end

  def persistent=(value)
    @property_flush[:persistent] = value
  end

end
