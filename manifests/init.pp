# == Class freebox
#
# A module for managing freebox configuration.
#
class freebox(
  $app_token,
  $app_id      = 'fr.freebox.puppet',
  $app_name    = 'Freebox Puppet',
  $app_version = '0.0.1',
  $device_name = $::hostname,
  $port        = '80',
) {
  file {'/etc/puppet/freebox.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
  }

  Ini_setting {
    ensure  => 'present',
    path    => '/etc/puppet/freebox.conf',
    section => $::clientcert,
    require => File['/etc/puppet/freebox.conf'],
  }

  ini_setting { 'set app_id':
    setting => 'app_id',
    value   => $app_id,
  }

  ini_setting { 'set app_token':
    setting => 'app_token',
    value   => $app_token,
  }

  ini_setting { 'set port':
    setting => 'port',
    value   => $port,
  }
}
