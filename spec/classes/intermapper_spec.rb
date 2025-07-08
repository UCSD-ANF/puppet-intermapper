require 'spec_helper'

describe 'intermapper', type: :class do
  ['CentOS', 'RedHat', 'Debian', 'Ubuntu'].each do |system|
    context "when on system #{system}" do
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
      elsif ['Debian', 'Ubuntu'].include?(system)
        let(:facts) do
          {
            os: {
              family: 'Debian',
              name: system,
            },
            osfamily: 'Debian',
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

      it { is_expected.to contain_class('intermapper::repo') }
      it { is_expected.to contain_class('intermapper::install') }
      it { is_expected.to contain_class('intermapper::nagios') }
      it { is_expected.to contain_class('intermapper::service') }
      it { is_expected.to contain_class('intermapper::service_extra') }

      describe 'intermapper::install' do
        let(:params) do
          {
            package_ensure: 'present',
            package_name: 'intermapper',
            package_manage: true,
          }
        end

        it { is_expected.to contain_package('intermapper').with_ensure('present').with_tag('intermapper') }

        describe 'should allow package ensure to be overridden' do
          let(:params) do
            {
              package_ensure: 'latest',
              package_name: 'intermapper',
            }
          end

          it { is_expected.to contain_package('intermapper').with_ensure('latest').with_tag('intermapper') }
        end

        describe 'should allow the package name to be overridden' do
          let(:params) do
            {
              package_name: 'foo',
            }
          end

          it { is_expected.to contain_package('foo').with_tag('intermapper') }
        end

        describe 'should allow the package name to be an array of names' do
          let(:params) do
            {
              package_name: ['foo', 'bar'],
            }
          end

          it { is_expected.to contain_package('foo').with_tag('intermapper') }
          it { is_expected.to contain_package('bar').with_tag('intermapper') }
        end

        describe 'should allow the package to be unmanaged' do
          let(:params) do
            {
              package_name: 'intermapper',
              package_manage: false,
            }
          end

          it { is_expected.not_to contain_package('intermapper') }
        end

        describe 'should allow the provider to be overridden' do
          let(:params) do
            {
              package_name: 'intermapper',
              package_provider: 'somethingcool',
            }
          end

          it {
            is_expected.to contain_package('intermapper').with_provider(
              'somethingcool',
            ).with_tag('intermapper')
          }
        end
      end # describe intermapper::install

      describe 'intermapper::service' do
        let(:params) do
          {
            service_name: 'intermapperd',
          }
        end

        describe 'with defaults' do
          it {
            is_expected.to contain_service('intermapperd').with(hasstatus: true,
                                                                ensure: 'running',
                                                                enable: true)
          }
        end

        describe 'service_manage when false' do
          let(:params) do
            {
              service_name: 'intermapperd',
              service_manage: false,
            }
          end

          it { is_expected.not_to contain_service('intermapperd') }
        end

        describe 'service_ensure when overridden' do
          let(:params) do
            {
              service_name: 'intermapperd',
              service_ensure: 'stopped',
            }
          end

          it {
            is_expected.to contain_service('intermapperd')\
              .with_ensure('stopped')\
              .with_enable(false)
          }
        end
      end # describe intermapper::service

      describe 'intermapper::service_extra' do
        let(:params) do
          {
            service_imdc_name: 'imdc',
            service_imflows_name: 'imflows',
          }
        end

        describe 'with defaults' do
          it {
            is_expected.to contain_service('imdc').with(hasstatus: true,
                                                        ensure: 'stopped',
                                                        enable: false)
          }
          it {
            is_expected.to contain_service('imflows').with(hasstatus: true,
                                                           ensure: 'stopped',
                                                           enable: false)
          }
        end

        describe 'service_manage' do
          describe 'when false' do
            let(:params) do
              super().merge(service_manage: false)
            end

            it { is_expected.not_to contain_service('imdc') }
            it { is_expected.not_to contain_service('imflows') }

            describe 'and extra services manage is true' do
              let(:params) do
                super().merge(service_imdc_manage: true,
                              service_imflows_manage: true)
              end

              it { is_expected.not_to contain_service('imdc') }
              it { is_expected.not_to contain_service('imflows') }
            end
          end

          describe 'when true' do
            let(:params) do
              super().merge(service_manage: true)
            end

            describe 'and extra services manage is false' do
              let(:params) do
                super().merge(service_imdc_manage: false,
                              service_imflows_manage: false)
              end

              it { is_expected.not_to contain_service('imdc') }
              it { is_expected.not_to contain_service('imflows') }
            end

            describe 'and extra services manage is true' do
              let(:params) do
                super().merge(service_imdc_manage: true,
                              service_imflows_manage: true)
              end

              it { is_expected.to contain_service('imdc') }
              it { is_expected.to contain_service('imflows') }
            end
          end
        end

        describe 'service_imdc_ensure when overridden' do
          let(:params) do
            super().merge(service_imdc_ensure: 'running')
          end

          it {
            is_expected.to contain_service('imdc')\
              .with_ensure('running')\
              .with_enable(true)
          }
        end
        describe 'service_imflows_ensure when overridden' do
          let(:params) do
            super().merge(service_imflows_ensure: 'running')
          end

          it {
            is_expected.to contain_service('imflows')\
              .with_ensure('running')\
              .with_enable(true)
          }
        end
      end # describe intermapper::service

      describe 'intermapper::repo' do
        describe 'with defaults (repo_manage = false)' do
          it { is_expected.not_to contain_apt__source('intermapper') }
        end

        if ['Debian', 'Ubuntu'].include?(system)
          describe 'with repo_manage = true on Debian/Ubuntu' do
            let(:params) do
              {
                repo_manage: true,
              }
            end

            it { is_expected.to contain_apt__source('intermapper').with_location('https://hsdownloads.helpsystems.com/intermapper/debian') }
            it { is_expected.to contain_apt__source('intermapper').with_key('name' => 'intermapper-release-key', 'source' => 'https://hsdownloads.helpsystems.com/intermapper/debian/fortra-release-public.asc') }
          end

          describe 'with repo_manage = true and custom parameters' do
            let(:params) do
              {
                repo_manage: true,
                repo_url: 'https://custom.repo.example.com/intermapper',
                repo_key_source: 'https://custom.repo.example.com/key.asc',
                repo_release: 'stable',
                repo_repos: 'main contrib',
              }
            end

            it { is_expected.to contain_apt__source('intermapper').with_location('https://custom.repo.example.com/intermapper') }
            it { is_expected.to contain_apt__source('intermapper').with_key('name' => 'intermapper-release-key', 'source' => 'https://custom.repo.example.com/key.asc') }
            it { is_expected.to contain_apt__source('intermapper').with_release('stable') }
            it { is_expected.to contain_apt__source('intermapper').with_repos('main contrib') }
          end
        end
      end # describe intermapper::repo

      describe 'intermapper::nagios' do
        describe 'with defaults' do
          it {
            is_expected.not_to contain_intermapper__nagios_plugin_link('check_nrpe')
          }
        end
        describe 'nagios_manage' do
          describe 'when true' do
            describe 'with nagios_ensure == present and plugins dir UNSET' do
              let(:params) do
                {
                  nagios_manage: true,
                  nagios_ensure: 'present',
                }
              end

              it { is_expected.to raise_error(Puppet::Error, %r{must be specified}) }
            end

            describe 'with nagios_ensure == present and plugins dir set' do
              let(:params) do
                {
                  nagios_manage: true,
                  nagios_ensure: 'present',
                  nagios_plugins_dir: '/usr/lib64/nagios-plugins',
                }
              end

              # This is a subset of the defaults in intermapper::params
              ['check_nrpe', 'check_disk', 'check_file_age'].each do |nplugin|
                it {
                  is_expected.to contain_intermapper__nagios_plugin_link(nplugin).with(ensure: 'present',
                                                                                       nagios_plugins_dir: '/usr/lib64/nagios-plugins')
                }
              end
            end

            describe 'when nagios_ensure == absent' do
              let(:params) do
                {
                  nagios_manage: true,
                  nagios_ensure: 'absent',
                }
              end

              ['check_nrpe', 'check_disk', 'check_file_age'].each do |nplugin|
                it {
                  is_expected.to contain_intermapper__nagios_plugin_link(nplugin).with(ensure: 'absent',
                                                                                       nagios_plugins_dir: nil)
                }
              end
            end
          end # describe when_true
        end # describe nagios_manage

        describe 'nagios_link_plugins' do
          describe 'should allow overrides' do
            pnames = ['foo', 'bar', 'baz']
            let(:params) do
              {
                nagios_manage: true,
                nagios_plugins_dir: '/usr/lib64/nagios-plugins',
                nagios_link_plugins: pnames,
              }
            end

            pnames.each do |p|
              it { is_expected.to contain_intermapper__nagios_plugin_link(p) }
            end
          end
        end # describe nagios_link_plugins
      end # describe intermapper::nagios
    end # when on system
  end # os each block

  # OS-specific behavior driven by defaults starts here
  context 'default driven behavior' do
    context 'on RedHat osfamily' do
      ['RedHat', 'CentOS'].each do |osname|
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

          describe 'intermapper::service' do
            it {
              is_expected.to contain_service('intermapperd').with(provider: nil,
                                                                  status: nil)
            }
          end
        end

        context 'with comprehensive nagios plugin testing' do
          ['RedHat', 'CentOS'].each do |os_name|
            context "with operatingsystem == #{os_name}" do
              let(:facts) do
                {
                  os: {
                    family: 'RedHat',
                    name: os_name,
                  },
                  osfamily: 'RedHat',
                  operatingsystem: os_name,
                }
              end

              describe 'with nagios enabled and all plugins' do
                let(:params) do
                  {
                    nagios_manage: true,
                    nagios_ensure: 'present',
                    nagios_plugins_dir: '/usr/lib64/nagios-plugins',
                    nagios_link_plugins: [
                      'check_nrpe', 'check_disk', 'check_file_age',
                      'check_ftp', 'check_icmp', 'check_mailq',
                      'check_procs', 'check_snmp', 'check_tcp', 'check_udp'
                    ],
                  }
                end

                # Test that all the nagios plugin links are created
                [
                  'check_nrpe', 'check_disk', 'check_file_age',
                  'check_ftp', 'check_icmp', 'check_mailq',
                  'check_procs', 'check_snmp', 'check_tcp', 'check_udp'
                ].each do |plugin|
                  it do
                    is_expected.to contain_intermapper__nagios_plugin_link(plugin).with(
                      ensure: 'present',
                      nagios_plugins_dir: '/usr/lib64/nagios-plugins',
                    )
                  end

                  # These should create intermapper::tool resources
                  it do
                    is_expected.to contain_intermapper__tool(plugin).with(
                      ensure: 'link',
                      target: "/usr/lib64/nagios-plugins/#{plugin}",
                    )
                  end

                  # These should create File resources in Tools directory
                  it do
                    is_expected.to contain_file("/var/local/InterMapper_Settings/Tools/#{plugin}").with(
                      ensure: 'link',
                      target: "/usr/lib64/nagios-plugins/#{plugin}",
                    )
                  end
                end
              end

              describe 'with custom tools to exercise more file resources' do
                let(:params) do
                  {
                    nagios_manage: true,
                    nagios_ensure: 'present',
                    nagios_plugins_dir: '/usr/lib64/nagios-plugins',
                    nagios_link_plugins: ['foo', 'bar', 'baz'],
                  }
                end

                ['foo', 'bar', 'baz'].each do |tool|
                  it do
                    is_expected.to contain_intermapper__tool(tool).with(
                      ensure: 'link',
                      target: "/usr/lib64/nagios-plugins/#{tool}",
                    )
                  end

                  it do
                    is_expected.to contain_file("/var/local/InterMapper_Settings/Tools/#{tool}").with(
                      ensure: 'link',
                      target: "/usr/lib64/nagios-plugins/#{tool}",
                    )
                  end
                end
              end

              describe 'with specific plugin to test my_nagios_plugin resource' do
                let(:params) do
                  {
                    nagios_manage: true,
                    nagios_ensure: 'present',
                    nagios_plugins_dir: '/usr/lib64/nagios-plugins',
                    nagios_link_plugins: ['my_nagios_plugin'],
                  }
                end

                it do
                  is_expected.to contain_intermapper__tool('my_nagios_plugin').with(
                    ensure: 'link',
                    target: '/usr/lib64/nagios-plugins/my_nagios_plugin',
                  )
                end
              end
            end
          end
        end

        context 'to test alternate package name' do
          context 'on system with InterMapper package' do
            let(:facts) do
              {
                os: {
                  family: 'RedHat',
                  name: 'RedHat',
                },
                osfamily: 'RedHat',
                operatingsystem: 'RedHat',
              }
            end

            describe 'with package_name InterMapper' do
              let(:params) do
                {
                  package_manage: true,
                  package_name: 'InterMapper',
                  package_ensure: 'present',
                }
              end

              it { is_expected.to contain_package('InterMapper').with_ensure('present').with_tag('intermapper') }
            end
          end
        end
      end
    end
  end
end
