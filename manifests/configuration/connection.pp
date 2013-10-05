# == Class: freebox::configuration::connection
#
# See README.md for more details.
#
class freebox::configuration::connection(
  $ping                = undef,
  $remote_access       = undef,
  $remote_access_port  = undef,
  $wol                 = undef,
  $adblock             = undef,
  $allow_token_request = undef,
) {
  freebox_configuration_connection { $::clientcert:
    params => {
      ping                => $ping,
      remote_access       => $remote_access,
      remote_access_port  => $remote_access_port,
      wol                 => $wol,
      adblock             => $adblock,
      allow_token_request => $allow_token_request,
    },
  }
}
