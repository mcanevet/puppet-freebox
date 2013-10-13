begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning 'You need freebox_api gem to manage Freebox OS with this provider.'
end

Puppet::Type.type(:freebox_dmz_conf).provide(:bindings) do

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
    FreeboxApi::Configuration::Nat::Dmz.getConfig(session)
    .select { |k,_| %w[ip enabled].include? k }
    .collect { |k, v|
      v = :true if v == true
      v = :false if v == false
      new(
        :name   => :"#{k}",
        :value  => v,
      )
    }
  end

  def self.prefetch(resources)
    params = instances
    resources.keys.each do |name|
      if provider = params.find{ |param| param.name == name }
        resources[name].provider = provider
      end
    end
  end

  mk_resource_methods

  def value=(v)
    val = v
    val = true if v == :true
    val = false if v == :false
    FreeboxApi::Configuration::Nat::Dmz.updateConfig(self.class.session, {@resource[:name] => val})
    @property_hash[:value] = v
  end

end

