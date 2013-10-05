require 'spec_helper'

describe 'freebox::configuration::lan', :type => 'class' do

  context 'when no parameter given' do
    let (:params) { { } }
    it { should create_class('freebox::configuration::lan') }
  end

end
