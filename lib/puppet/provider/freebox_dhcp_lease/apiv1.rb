begin
  require 'rest_client'
  require 'json'
  require 'inifile'
rescue
  Puppet.warning "You need REST_Client and Json installed to manage Freebox OS."
end

Puppet::Type.type(:freebox_dhcp_lease).provide(:apiv1) do

  def self.session_token
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    app_token = section['app_token']

    # Get challenge
    challenge = JSON.parse(RestClient.get('http://mafreebox.free.fr/api/v1/login/'))['result']['challenge']
    password = Digest::HMAC.hexdigest(challenge, app_token, Digest::SHA1)

    # Get session_token
    JSON.parse(
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
  end

  def session_token
    ini = IniFile.load('/etc/puppet/freebox.conf')
    section = ini['mafreebox.free.fr']
    app_token = section['app_token']

    # Get challenge
    challenge = JSON.parse(RestClient.get('http://mafreebox.free.fr/api/v1/login/'))['result']['challenge']
    password = Digest::HMAC.hexdigest(challenge, app_token, Digest::SHA1)

    # Get session_token
    JSON.parse(
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
  end

  def self.instances
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

  def self.prefetch(resources)
    dhcp_leases = instances
    resources.keys.each do |name|
      if provider = dhcp_leases.find{ |dhcp_lease| dhcp_lease.name == name }
        resources[name].provider = provider
      end
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
      :'X_Fbx_App_Auth' => self.session_token
    )
  end

  def destroy
    RestClient.delete(
      "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:name]}",
      :'X_Fbx_App_Auth' => self.session_token
    )
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def mac
    @property_hash[:mac]
  end

  def mac=(value)
    @property_flush[:mac] = value
  end

  def comment
    @property_hash[:comment]
  end

  def comment=(value)
    @property_flush[:comment] = value
  end

  def hostname
    @property_hash[:hostname]
  end

  def hostname=(value)
    @property_flush[:hostname] = value
  end

  def ip
    @property_hash[:ip]
  end

  def ip=(value)
    @property_flush[:ip] = value
  end

  def flush
    myHash = {}
    if @property_flush
      (myHash[:mac] = resource[:mac]) if @property_flush[:mac]
      (myHash[:comment] = resource[:comment]) if @property_flush[:comment]
      (myHash[:hostname] = resource[:hostname]) if @property_flush[:hostname]
      (myHash[:ip] = resource[:ip]) if @property_flush[:ip]
      puts "myHash=#{myHash}"
      unless myHash.empty?
        RestClient.put(
          "http://mafreebox.free.fr/api/v1/dhcp/static_lease/#{resource[:name]}",
          myHash.to_json,
          :'X_Fbx_App_Auth' => self.session_token
        )
      end
    end
    @property_hash = resource.to_hash
  end

end
