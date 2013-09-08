begin
  require 'rest_client'
  require 'json'
rescue
  Puppet.warning "You need REST_Client and Json installed to manage Freebox OS."
end

Puppet::Type.type(:freebox_dhcp_lease).provide(:apiv1) do

  def exists?
    JSON.parse(
      RestClient.get(
        "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
        :'X_Fbx_App_Auth' => resource[:session_token]
      )
    )['success']
  end

  def create
    RestClient.post(
      "http://mafreebox.free.fr/api/v1/dhcp/static_lease/",
      {
        :ip => resource[:ip],
        :mac => resource[:mac],
        :comment => resource[:comment],
        :hostname => resource[:hostname],
      }.to_json,
      :'X_Fbx_App_Auth' => resource[:session_token]
    )
  end

  def id
    resource[:id]
  end

  def mac
    JSON.parse(
      RestClient.get(
        "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
        :'X_Fbx_App_Auth' => resource[:session_token]
      )
    )['result']['mac']
  end

  def mac=(value)
    RestClient.put(
      "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
      {
        :mac => resource[:mac],
      }.to_json,
      :'X_Fbx_App_Auth' => resource[:session_token]
    )
  end

  def comment
    JSON.parse(
      RestClient.get(
        "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
        :'X_Fbx_App_Auth' => resource[:session_token]
      )
    )['result']['comment']
  end

  def comment=(value)
    RestClient.put(
      "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
      {
        :comment => resource[:comment],
      }.to_json,
      :'X_Fbx_App_Auth' => resource[:session_token]
    )
  end

  def hostname
    JSON.parse(
      RestClient.get(
        "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
        :'X_Fbx_App_Auth' => resource[:session_token]
      )
    )['result']['hostname']
  end

  def hostname=(value)
    RestClient.put(
      "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
      {
        :hostname => resource[:hostname],
      }.to_json,
      :'X_Fbx_App_Auth' => resource[:session_token]
    )
  end

  def ip
    JSON.parse(
      RestClient.get(
        "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
        :'X_Fbx_App_Auth' => resource[:session_token]
      )
    )['result']['ip']
  end

  def ip=(value)
    RestClient.put(
      "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:id]}",
      {
        :ip => resource[:ip],
      }.to_json,
      :'X_Fbx_App_Auth' => resource[:session_token]
    )
  end

end
