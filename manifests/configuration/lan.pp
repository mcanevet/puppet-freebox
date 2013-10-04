# == Class:: freebox::configuration::lan
#
# See README.md for more details.
#
class freebox::configuration::lan(
  $ip           = '192.168.0.254',
  $server_name  = 'Freebox Server',
  $name_dns     = 'freebox-server',
  $name_mdns    = 'Freebox-Server',
  $name_netbios = 'Freebox_Server',
  $mode         = 'router',
  $hosts        = {},
) {
  freebox_conf { 'lan':
    params => {
      ip           => $ip,
      name         => $server_name,
      name_dns     => $name_dns,
      name_mdns    => $name_mdns,
      name_netbios => $name_netbios,
      mode         => $mode,
    }
  }
  create_resources(freebox_lan_host, $hosts)
}
