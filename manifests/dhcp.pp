# == Class: freebox::dhcp
#
class freebox::dhcp(
  $enable           = true,
  $sticky_assign    = undef,
  $ip_range_start   = undef,
  $ip_range_end     = undef,
  $always_broadcast = undef,
  $dns              = [],
  $leases           = {},
) {
  freebox_conf { '/api/v1/dhcp/config/':
    app_id    => $::freebox::app_id,
    app_token => $::freebox::app_token,
    request   => {
      enable           => $enable,
      sticky_assign    => $sticky_assign,
      ip_range_start   => $ip_range_start,
      ip_range_end     => $ip_range_end,
      always_broadcast => $always_broadcast,
      dns              => $dns,
    }
  }
  create_resources(freebox::dhcp::lease, $leases)
}
