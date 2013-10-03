require 'inifile'
require 'freebox_api'

Facter.add(:ipaddress6) do
  confine :operatingsystem => 'FreeboxOS'
  has_weight 100
  setcode do
    clientcert = Facter['clientcert'] == nil ? 'mafreebox.free.fr' : Facter['clientcert'].value

    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini[clientcert]
    app_id = section['app_id']
    app_token = section['app_token']
    port = section['port']

    FreeboxApi::Configuration::Connection.getStatus(
      FreeboxApi::Session.new(
        {:app_id => 'fr.freebox.puppet', :app_token => app_token},
        FreeboxApi::Freebox.new({
          :freebox_ip   => clientcert,
          :freebox_port => port,
        })
      )
    )['ipv6']
  end
end

