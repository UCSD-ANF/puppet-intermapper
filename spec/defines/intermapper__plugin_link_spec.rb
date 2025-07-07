require 'spec_helper'

describe 'intermapper::nagios_plugin_link', type: :define do
  npd = '/usr/lib64/nagios-plugins'
  t = 'my_nagios_plugin'
  baseparams = {
    'nagios_plugins_dir' => npd,
  }
  let(:title) { t }

  targetfname = "#{npd}/#{t}"
  fname = "/var/local/InterMapper_Settings/Tools/#{t}"

  ['CentOS', 'RedHat'].each do |system|
    context "when on system #{system}" do
      let(:params) { baseparams }

      if system == 'CentOS'
        let(:facts) do
          {
            os: {
              family: 'RedHat',
              name: system,
            },
            osfamily: 'RedHat',
            operatingsystem: system,
          }
        end
      else
        let(:facts) do
          {
            os: {
              family: system,
              name: system,
            },
            osfamily: system,
            operatingsystem: system,
          }
        end
      end

      describe 'with defaults' do
        it {
          is_expected.to contain_file(fname)\
            .that_notifies('Class[intermapper::service]')
        }
      end

      {
        present: [:link, targetfname],
        link: [:link, targetfname],
        absent: [:absent, nil],
        missing: [:absent, nil],
      }.each do |k, v|
        context "with ensure == #{k}" do
          let(:params) do
            super().merge(ensure: k.to_s)
          end

          it do
            is_expected.to contain_file(fname).with(ensure: v[0],
                                                    target: v[1])
          end
        end
      end
    end # context when on system
  end # system each
end
