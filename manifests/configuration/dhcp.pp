# == Class: freebox::configuration::dhcp
#
# See README.md for more details.
#
class freebox::configuration::dhcp(
  $enabled          = undef,
  $sticky_assign    = undef,
  $ip_range_start   = undef,
  $ip_range_end     = undef,
  $always_broadcast = undef,
  $dns              = undef,
  $static_leases    = {},
) {
  freebox_dhcp_conf {
    'enabled':
      value => $enabled;
    'sticky_assign':
      value => $sticky_assign;
    'ip_range_start':
      value => $ip_range_start;
    'ip_range_end':
      value => $ip_range_end;
    'always_broadcast':
      value => $always_broadcast;
    'dns':
      value => $dns;
  }
  create_resources(freebox_static_lease, $static_leases)
}
