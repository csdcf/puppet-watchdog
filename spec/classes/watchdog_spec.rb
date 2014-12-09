require 'spec_helper'

describe 'watchdog' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it do
      expect { subject }.to raise_error(/not supported on an Unsupported/)
    end
  end

  context 'on RedHat' do
    let(:facts) do
      {
        :osfamily => 'RedHat'
      }
    end

    it do
      should contain_class('watchdog')
      should contain_file('/etc/watchdog.conf')
      should contain_package('watchdog')
      should contain_service('watchdog').with(
        'ensure' => 'running',
        'enable' => true
      )
    end
  end

  context 'on OpenBSD', :compile do
    let(:facts) do
      {
        :osfamily => 'OpenBSD'
      }
    end

    it do
      should contain_class('watchdog')
      should contain_service('watchdogd').with(
        'ensure' => 'running',
        'enable' => true,
        'flags'  => '-i 20 -p 60'
      )
      should contain_sysctl('kern.watchdog.period').with(
        'ensure' => 'absent'
      )
      should contain_sysctl('kern.watchdog.auto').with(
        'ensure' => 'present',
        'value'  => 0
      )
    end
  end
end
