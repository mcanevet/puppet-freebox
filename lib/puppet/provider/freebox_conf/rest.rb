begin
  require 'rest_client'
  require 'json'
rescue
  Puppet.warning "You need REST_Client and Json installed to manage Freebox OS."
end

Puppet::Type.type(:freebox_conf).provide(:rest) do

  def session_token
    freebox_session_token(resource[:app_id], resource[:app_token])
  end

  def request
    JSON.parse(RestClient.get(
      "http://mafreebox.free.fr#{resource[:name]}",
      resource[:request].to_json,
      :headers => {
        :X_Fbx_App_Auth => session_token,
      }
    ))
  end

  def request=(value)
    RestClient.put(
      "http://mafreebox.free.fr#{resource[:name]}",
      resource[:request].to_json,
      :headers => {
        :X_Fbx_App_Auth => session_token,
      }
    )
  end

  def exists?
    request == resource[:request]
  end

  def create
#    request = resource[:request]
  end

end
