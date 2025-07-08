require 'spec_helper'

describe 'intermapper::icon', type: :define do
  t = 'edu.ucsd.testicon'
  td = '/var/opt/helpsystems/intermapper/InterMapper_Settings/Custom Icons' # new default directory
  fname = "#{td}/#{t}"
  let(:title) { t }

  ['CentOS', 'RedHat'].each do |system|
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
            .that_notifies('Class[intermapper::service]')\
            .that_requires('Class[intermapper::install]')\
            .with_force(nil)\
            .with_content(nil)\
            .with_source(nil)\
            .with_target(nil)\
            .with_owner('intermapper')\
            .with_group('intermapper')
        }
      end

      describe 'force' do
        [true, false].each do |tf|
          describe "is #{tf}" do
            let(:params) do
              {
                force: tf,
              }
            end

            it { is_expected.to contain_file(fname).with_force(tf) }
          end
        end
      end

      describe 'content is set' do
        c = 'This is probe content'
        let(:params) do
          {
            content: c,
          }
        end

        it { is_expected.to contain_file(fname).with_content(c) }
      end

      describe 'source is set' do
        s = '/tmp/testfile'
        let(:params) do
          {
            source: s,
          }
        end

        it { is_expected.to contain_file(fname).with_source(s) }
      end

      describe 'mode is set' do
        m = '0755'
        let(:params) do
          {
            mode: m,
          }
        end

        it { is_expected.to contain_file(fname).with_mode(m) }
      end

      describe 'linking' do
        tgt = '/tmp/sourcefile'

        describe 'with ensure == link and target set' do
          let(:params) do
            {
              ensure: 'link',
              target: tgt,
            }
          end

          it {
            is_expected.to contain_file(fname).with(ensure: 'link',
                                                    target: tgt)
          }
        end

        describe 'with ensure set to link target' do
          let(:params) do
            {
              ensure: tgt,
            }
          end

          it { is_expected.to contain_file(fname).with_ensure(tgt) }
        end
      end
    end # on system
  end # each system
end
