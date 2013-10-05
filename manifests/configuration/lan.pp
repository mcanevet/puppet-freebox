# == Class:: freebox::configuration::lan
#
# See README.md for more details.
#
class freebox::configuration::lan(
  $ip           = undef,
  $server_name  = undef,
  $name_dns     = undef,
  $name_mdns    = undef,
  $name_netbios = undef,
  $mode         = undef,
  $hosts        = {},
) {
  freebox_lan_conf {
    'ip':
      value => $ip;
    'server_name':
      value => $server_name;
    'name_dns':
      value => $name_dns;
    'name_mdns':
      value => $name_mdns;
    'name_netbios':
      value => $name_netbios;
    'mode':
      value => $mode;
  }
  create_resources(freebox_lan_host, $hosts)
}
