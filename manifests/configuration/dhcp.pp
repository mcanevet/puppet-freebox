# == Class: freebox::dhcp
#
# See README.md for more details.
#
class freebox::configuration::dhcp(
  $always_broadcast = undef,
  $dns              = undef,
  $enabled          = undef,
  $gateway          = undef,
  $ip_range_end     = undef,
  $ip_range_start   = undef,
  $netmask          = undef,
  $sticky_assign    = undef,
  $static_leases    = {},
) {
  freebox_conf { 'dhcp':
    params => {
      always_broadcast => $always_broadcast,
      dns              => $dns,
      enabled          => $enabled,
      gateway          => $gateway,
      ip_range_end     => $ip_range_end,
      ip_range_start   => $ip_range_start,
      netmask          => $netmask,
      sticky_assign    => $sticky_assign,
    }
  }
  create_resources(freebox_static_lease, $static_leases)
}
