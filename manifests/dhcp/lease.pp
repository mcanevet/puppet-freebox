# == Define: freebox::dhcp::lease
#
define freebox::dhcp::lease(
  $mac,
  $ip,
  $comment = undef,
  $hostname = undef,
) {
  freebox_conf { "/api/v1/dhcp/static_lease/${name}":
    app_id    => $::freebox::app_id,
    app_token => $::freebox::app_token,
    request   => {
      id       => $name,
      mac      => $mac,
      comment  => $comment,
      hostname => $hostname,
      ip       => $ip,
    }
  }
}
