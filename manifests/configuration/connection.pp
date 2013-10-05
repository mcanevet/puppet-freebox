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
  $ddns_clients        = {},
) {
  freebox_connection_conf {
    'ping':
      value => $ping;
    'remote_access':
      value => $remote_access;
    'remote_access_port':
      value => $remote_access_port;
    'wol':
      value => $wol;
    'adblock':
      value => $adblock;
    'allow_token_request':
      value => $allow_token_request;
  }
  create_resources(freebox_ddns_client, $ddns_clients)
}
