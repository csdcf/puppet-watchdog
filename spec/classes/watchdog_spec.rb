require 'spec_helper'

describe 'watchdog' do

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      it { should contain_anchor('watchdog::begin') }
      it { should contain_anchor('watchdog::end') }
      it { should contain_class('watchdog') }
      it { should contain_class('watchdog::config') }
      it { should contain_class('watchdog::install') }
      it { should contain_class('watchdog::params') }
      it { should contain_class('watchdog::service') }

      case facts[:osfamily]
      when 'OpenBSD'
        it { should contain_service('watchdogd').with_flags('-i 20 -p 60') }
        it { should contain_sysctl('kern.watchdog.period').with_ensure('absent') }
        it { should contain_sysctl('kern.watchdog.auto').with(
        'ensure' => 'present',
        'value'  => 0
        ) }
      when 'RedHat'
        it { should contain_file('/etc/watchdog.conf') }
        it { should contain_package('watchdog') }
        it { should contain_service('watchdog') }
      end
    end
  end
end
