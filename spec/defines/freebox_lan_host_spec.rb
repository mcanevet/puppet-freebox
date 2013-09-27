require 'spec_helper'

describe 'freebox_lan_host', :type => :define do

  let (:title) { 'foo' }

  context 'when no paramters' do
    let (:params) { { } }
    it { should create_freebox_lan_host('foo') }
  end

end
