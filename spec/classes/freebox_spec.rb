require 'spec_helper'

describe 'freebox', :type => 'class' do

  context 'when no parameter given' do
    let (:params) { { } }
    it 'should fail' do
      expect { should contain_file('/etc/puppet/freebox.conf') }.to raise_error(Puppet::Error, /Must pass app_token to Class\[Freebox\]/)
    end
  end

  context 'when an app_token is specified' do
    let (:params) { {
      :app_token => 'dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0',
    } }
    it { should create_class('freebox')\
      .with_app_token('dyNYgfK0Ya6FWGqq83sBHa7TwzWo+pg4fDFUJHShcjVYzTfaRrZzm93p7OTAfH/0')\
      .with_app_id('fr.freebox.puppet')\
      .with_app_name('Freebox Puppet')\
      .with_app_version('0.0.1')\
      .with_ping(nil)\
      .with_remote_access(nil)\
      .with_remote_access_port(nil)\
      .with_wol(nil)\
      .with_adblock(nil)\
      .with_allow_token_request(nil)
    }
    it { should contain_file('/etc/puppet/freebox.conf')\
      .with_owner('root')\
      .with_group('root')\
      .with_mode('0400')
    }
  end

end
