require 'rest_client'
require 'json'
require 'base64'
require 'openssl'

Puppet::Parser::Functions.newfunction(:freebox_session_token, :type => :rvalue) do | args|
  app_id    = args[0]
  app_token = args[1]
  challenge = JSON.parse(RestClient.get('http://mafreebox.free.fr/api/v1/login/'))['result']['challenge']
  password  = Base64.encode64("#{OpenSSL::HMAC.digest('sha1', app_token, challenge)}\n")
  RestClient.post(
    'http://mafreebox.free.fr/api/v1/login/session/',
    {
      :app_id   => app_id,
      :password => password,
    }.to_json,
    :content_type => :json,
    :accept => :json
  )
end
