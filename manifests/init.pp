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
  # TODO: Don't override the file, add a section per clientcert
  # Maybe use augeas for that
  file { '/etc/puppet/freebox.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => "[${::clientcert}]
app_id=${app_id}
app_token=${app_token}
port=${port}
",
  }
}
