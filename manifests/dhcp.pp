# == Class: freebox::dhcp
#
class freebox::dhcp(
  $always_broadcast = undef,
  $dns              = undef,
  $enabled          = undef,
  $gateway          = undef,
  $ip_range_end     = undef,
  $ip_range_start   = undef,
  $netmask          = undef,
  $sticky_assign    = undef,
  $leases           = {},
) {
  freebox_conf { '/api/v1/dhcp/config/':
    session_token => freebox_session_token(
      $::freebox::app_id, $::freebox::app_token),
    request       => {
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
  create_resources(freebox::dhcp::lease, $leases)
}
