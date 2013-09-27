require 'spec_helper'

describe 'freebox::lan', :type => 'class' do

  context 'when no parameter given' do
    let (:params) { { } }
    it { should create_class('freebox::lan') }
  end

end
