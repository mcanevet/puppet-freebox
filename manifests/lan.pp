# == Class:: freebox::lan
#
class freebox::lan(
  $ip           = '192.168.0.254',
  $server_name  = 'Freebox Server',
  $name_dns     = 'freebox-server',
  $name_mdns    = 'Freebox-Server',
  $name_netbios = 'Freebox_Server',
  $type         = 'router',
  $hosts        = {},
) {
  create_resources(freebox_lan_host, $hosts)
}
