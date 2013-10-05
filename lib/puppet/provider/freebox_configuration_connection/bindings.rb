begin
  require 'freebox_api'
  require 'inifile'
rescue
  Puppet.warning "You need freebox_api gem to manage Freebox OS with this provider."
end

Puppet::Type.type(:freebox_configuration_connection).provide(:bindings) do

  def clientcert
    @clientcert ||= Facter['clientcert'] == nil ? 'mafreebox.free.fr' : Facter['clientcert'].value
  end

  def inisection
    @inisection ||= IniFile.load('/etc/puppet/freebox.conf')[clientcert]
  end

  def app_id
    @app_id ||= inisection['app_id']
  end

  def app_token
    @app_token ||= inisection['app_token']
  end

  def port
    @port ||= inisection['port']
  end

  def session
    @session ||= FreeboxApi::Session.new(
      {:app_id => 'fr.freebox.puppet', :app_token => app_token},
      FreeboxApi::Freebox.new({
        :freebox_ip   => clientcert,
        :freebox_port => port,
      })
    )
  end

  def params
    FreeboxApi::Configuration::Connection.getConfig(session)
  end

  def params=(value)
    FreeboxApi::Configuration::Connection.updateConfig(session, value)
  end

end
