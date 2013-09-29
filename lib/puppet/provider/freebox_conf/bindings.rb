begin
  require 'freebox_api'
rescue
  Puppet.warning "You need freebox_api gem installed to manage Freebox OS."
end

Puppet::Type.type(:freebox_conf).provide(:bindings) do

  def app_token
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    section['app_token']
  end

  def session
    FreeboxApi::Session.new(
      {:app_id => 'fr.freebox.puppet', :app_token => app_token},
      FreeboxApi::Freebox.new)
  end

  def config
    config = FreeboxApi::Config.new(session)
  end

  def params
    config.show(resource[:name])
  end

  def params=(value)
    config.update(resource[:name], value)
  end

end
