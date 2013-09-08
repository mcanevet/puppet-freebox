begin
  require 'rest_client'
  require 'json'
rescue
  Puppet.warning "You need REST_Client and Json installed to manage Freebox OS."
end

Puppet::Type.type(:freebox_conf).provide(:rest) do

  def request
    RestClient.get(
      "http://mafreebox.free.fr#{resource[:name]}",
      :'X_Fbx_App_Auth' => resource[:session_token]
    ) { |response, request, result, &block|
      case response.code
      when 200
        JSON.parse(response)['result']
      else
        response.return!(request, result, &block)
      end
    }
  end

  def request=(value)
    RestClient.put(
      "http://mafreebox.free.fr#{resource[:name]}",
      value.to_json,
      :content_type => :json,
      :accept => :json,
      :'X_Fbx_App_Auth' => resource[:session_token]
    ) { |response, request, result, &block|
      case response.code
      when 200
        response
      else
        response.return!(request, result, &block)
      end
    }
  end

end
