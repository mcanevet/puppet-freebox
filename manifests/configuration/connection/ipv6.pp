# == Class: freebox::configuration::connection::ipv6
#
# See README.md for more details.
#
class freebox::configuration::connection::ipv6(
  $enabled     = undef,
  $delegations = undef,
) {
  freebox_connection_ipv6_conf {
    'ipv6_enabled':
      value => $enabled;
    'delegations':
      value => $delegations;
  }
}
