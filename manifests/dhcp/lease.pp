# == Define: freebox::dhcp::lease
#
define freebox::dhcp::lease(
  $ip,
  $mac      = $name,
  $comment  = '',
  $hostname = $name,
) {
  freebox_dhcp_lease { $name:
    session_token => freebox_session_token(
      $::freebox::app_id, $::freebox::app_token),
    ip            => $ip,
    mac           => $mac,
    comment       => $comment,
    hostname      => $hostname,
  }
}
