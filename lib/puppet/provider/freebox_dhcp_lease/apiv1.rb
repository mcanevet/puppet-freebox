begin
  require 'rest_client'
  require 'json'
  require 'inifile'
rescue
  Puppet.warning "You need REST_Client and Json installed to manage Freebox OS."
end

Puppet::Type.type(:freebox_dhcp_lease).provide(:apiv1) do

  def self.instances
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    app_token = section['app_token']

    # Get challenge
    challenge = JSON.parse(RestClient.get('http://mafreebox.free.fr/api/v1/login/'))['result']['challenge']
    password = Digest::HMAC.hexdigest(challenge, app_token, Digest::SHA1)

    # Get session_token
    session_token = JSON.parse(
      RestClient.post(
        'http://mafreebox.free.fr/api/v1/login/session/',
        {
          :app_id   => 'fr.freebox.puppet',
          :password => password,
        }.to_json,
        :content_type => :json,
        :accept => :json
      )
    )['result']['session_token']

    # Get leases
    JSON.parse(
      RestClient.get(
        'http://mafreebox.free.fr/api/v1/dhcp/static_lease/',
        :'X_Fbx_App_Auth' => session_token
      )
    )['result'].collect do |lease|
      # initialize @property_hash
      new( :name  => lease['id'],
        :ensure   => :present,
        :mac      => lease['mac'],
        :comment  => lease['comment'],
        :hostname => lease['hostname'],
        :ip       => lease['ip']
      )
    end
  end

  def exists?
    @property_hash[:ensure] == :present
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

  def mac
    @property_hash[:mac]
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
    @property_hash[:comment]
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
    @property_hash[:hostname]
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
    @property_hash[:ip]
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
