Puppet::Type.newtype(:freebox_lan_host) do
  desc 'Type to manage Freebox LAN hosts'

  ensurable

  newparam(:name) do
    desc 'Host id (unique on this interface)'
  end

  newproperty(:primary_name) do
    desc "Host primary name (chosen from the list of available names, or manually set by user)"
  end

  newproperty(:host_type) do
    desc "When possible, the Freebox will try to guess the host_type, but you can manually override this to the correct value"
    newvalues(
      :workstation,
      :laptop,
      :smartphone,
      :tablet,
      :printer,
      :vg_console,
      :television,
      :nas,
      :ip_camera,
      :ip_phone,
      :freebox_player,
      :freebox_hd,
      :networking_device,
      :multimedia_device,
      :other,
    )
  end

  newproperty(:persistent) do
    desc "If true the host is always shown even if it has not been active since the Freebox startup"
    newvalues(:true, :false)
  end

end
