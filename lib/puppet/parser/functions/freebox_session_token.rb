require 'rest_client'
require 'json'
require 'digest/hmac'

Puppet::Parser::Functions.newfunction(:freebox_session_token, :type => :rvalue) do | args|
  app_id    = args[0]
  app_token = args[1]
  challenge = JSON.parse(RestClient.get('http://mafreebox.free.fr/api/v1/login/'))['result']['challenge']
  password = Digest::HMAC.hexdigest(challenge, app_token, Digest::SHA1)
  RestClient.post(
    'http://mafreebox.free.fr/api/v1/login/session/',
    {
      :app_id   => app_id,
      :password => password,
    }.to_json,
    :content_type => :json,
    :accept => :json
  ) { |response, request, result, &block|
    case response.code
    when 200
      JSON.parse(response)['result']['session_token']
    else
      response.return!(request, result, &block)
    end
  }
end
