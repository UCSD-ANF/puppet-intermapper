require 'spec_helper'

describe 'intermapper::params', type: :class do
  context 'on RedHat family' do
    ['RedHat', 'CentOS', 'Rocky', 'AlmaLinux'].each do |osname|
      context "with operatingsystem == #{osname}" do
        let(:facts) do
          {
            os: {
              family: 'RedHat',
              name: osname,
            },
            osfamily: 'RedHat',
            operatingsystem: osname,
          }
        end

        it { is_expected.to compile }
        
        it 'sets correct package defaults for RedHat family' do
          is_expected.to contain_class('intermapper::params')
        end
      end
    end
  end

  context 'on Solaris' do
    let(:facts) do
      {
        os: {
          family: 'Solaris',
          name: 'Solaris',
        },
        osfamily: 'Solaris',
        operatingsystem: 'Solaris',
      }
    end

    it { is_expected.to compile }
    
    it 'sets correct package defaults for Solaris' do
      is_expected.to contain_class('intermapper::params')
    end
  end

  context 'on unsupported OS' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Ubuntu',
        },
        osfamily: 'Debian',
        operatingsystem: 'Ubuntu',
      }
    end

    it { is_expected.to compile }
  end
end