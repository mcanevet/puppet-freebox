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
) {
  file { '/etc/puppet/freebox.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => "[mafreebox.free.fr]
app_token=${app_token}
",
  }
}
