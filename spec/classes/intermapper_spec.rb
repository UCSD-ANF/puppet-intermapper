require 'spec_helper'

describe 'intermapper', type: :class do
  ['CentOS', 'RedHat', 'Solaris'].each do |system|
    context "when on system #{system}" do
      if system == 'CentOS'
        let(:facts) do
          {
            osfamily: 'RedHat',
            operatingsystem: system,
          }
        end
      else
        let(:facts) do
          {
            osfamily: system,
            operatingsystem: system,
          }
        end
      end

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

        it { is_expected.to contain_package('intermapper').with_ensure('present') }

        describe 'should allow package ensure to be overridden' do
          let(:params) do
            {
              package_ensure: 'latest',
              package_name: 'intermapper',
            }
          end

          it { is_expected.to contain_package('intermapper').with_ensure('latest') }
        end

        describe 'should allow the package name to be overridden' do
          let(:params) do
            {
              package_name: 'foo',
            }
          end

          it { is_expected.to contain_package('foo') }
        end

        describe 'should allow the package name to be an array of names' do
          let(:params) do
            {
              package_name: ['foo', 'bar'],
            }
          end

          it { is_expected.to contain_package('foo') }
          it { is_expected.to contain_package('bar') }
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
            )
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
    context 'on Solaris' do
      let(:facts) do
        {
          osfamily: 'solaris',
          operatingsystem: 'solaris',
        }
      end

      describe 'intermapper::install' do
        it {
          is_expected.to contain_package('DARTinter').with(provider: 'sun')
        }
      end

      describe 'intermapper::service' do
        it {
          is_expected.to contain_service('intermapperd').with(provider: 'init',
                                                              status: '/usr/bin/pgrep intermapperd')
        }
      end
    end

    context 'on RedHat osfamily' do
      ['RedHat', 'CentOS'].each do |osname|
        context "with operatingsystem == #{osname}" do
          let(:facts) do
            {
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
      end
    end
  end
end
