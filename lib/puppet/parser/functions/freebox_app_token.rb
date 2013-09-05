require 'rest_client'
require 'json'

Puppet::Parser::Functions.newfunction(:freebox_app_token, :type => :rvalue) do |args|
  JSON.parse(RestClient.post(
    'http://mafreebox.free.fr/api/v1/login/authorize',
    {
      :app_id      => args[0],
      :app_name    => args[1],
      :app_version => args[2],
      :device_name => args[3],
    }.to_json,
    :content_type => :json,
    :accept => :json
  ))['result']['app_token']
end
