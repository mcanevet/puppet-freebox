# == Class freebox
#
# A module for managing freebox configuration.
#
class freebox(
  $app_id      = 'fr.freebox.puppet',
  $app_name    = 'Freebox Puppet',
  $app_version = '0.0.1',
  $device_name = $::hostname,
  $app_token   = freebox_app_token(
    $app_id,
    $app_name,
    $app_version,
    $device_name),
) {
}
