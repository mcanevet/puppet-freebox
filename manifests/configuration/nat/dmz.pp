# == Class: freebox::configuration::nat::dmz
#
# See README.md for more details.
#
class freebox::configuration::nat::dmz(
  $ip      = undef,
  $enabled = undef,
) {
  freebox_dmz_conf {
    'ip':
      value => $ip;
    'enabled':
      value => $enabled;
  }
}
