require 'spec_helper'
describe 'rapid7_scan_engine' do

  context 'with defaults for all parameters' do
    it { should contain_class('rapid7_scan_engine') }
  end
end
