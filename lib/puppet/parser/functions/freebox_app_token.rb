require 'rest_client'
require 'json'

Puppet::Parser::Functions.newfunction(:freebox_app_token, :type => :rvalue) do |args|
  app_id      = args[0]
  app_name    = args[1]
  app_version = args[2]
  device_name = args[3]
  RestClient.post(
    'http://mafreebox.free.fr/api/v1/login/authorize',
    {
      :app_id      => app_id,
      :app_name    => app_name,
      :app_version => app_version,
      :device_name => device_name,
    }.to_json,
    :content_type => :json,
    :accept => :json
  ) { |response, request, result, &block|
    case response.code
    when 200
      JSON.parse(response)['result']['app_token']
    else
      response.return!(request, result, &block)
    end
  }
end
