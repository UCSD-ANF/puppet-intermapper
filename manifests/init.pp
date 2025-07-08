# @summary Manages the InterMapper network monitoring package by Fortra
#
# This module installs and configures InterMapper, a network monitoring tool,
# along with its optional DataCenter and Flows services. It can also manage
# symlinks to Nagios plugins for use in InterMapper probes.
#
# @param basedir
#   The base directory where InterMapper is installed. Defaults to /usr/local
#   by the package. Useful if the package has been relocated.
#
# @param vardir
#   The directory that contains the InterMapper_Settings directory. Typically
#   /var/local on newer versions of InterMapper, but old versions had this set
#   to /usr/local.
#
# @param owner
#   The owner of any files that this module installs.
#
# @param group
#   The group of any files that this module installs.
#
# @param package_ensure
#   Can be set to a specific version of InterMapper, or to 'latest' to ensure
#   the package is always upgraded.
#
# @param package_manage
#   If false, the package will not be managed by this class.
#
# @param package_name
#   The name (or names) of the package to be installed. OS-specific defaults
#   are provided via Hiera data.
#
# @param package_provider
#   Package provider to use. OS-specific defaults are provided via Hiera data.
#
# @param package_source
#   Optional package source location for custom installations.
#
# @param service_ensure
#   Can be any valid value for the ensure parameter for a service resource type.
#
# @param service_manage
#   If false, none of the services are managed. Disables service_extra_manage.
#
# @param service_imdc_manage
#   Controls whether the extra service imdc is managed. Dependent on
#   service_manage being true.
#
# @param service_imflows_manage
#   Controls whether the extra service imflows is managed. Dependent on
#   service_manage being true.
#
# @param service_imdc_ensure
#   If service_manage is true, the InterMapper DataCenter services are set to
#   this value.
#
# @param service_imflows_ensure
#   If service_manage is true, the IMFlows services are set to this value.
#
# @param service_name
#   The name of the main service to manage. OS-specific defaults are provided
#   via Hiera data.
#
# @param service_imdc_name
#   The name of the InterMapper DataCenter service to manage.
#
# @param service_imflows_name
#   The name of the IMFlows service to manage.
#
# @param service_provider
#   Service provider to use. OS-specific defaults are provided via Hiera data.
#
# @param service_status_cmd
#   Custom status command. OS-specific defaults are provided via Hiera data.
#
# @param service_has_restart
#   Controls the behavior of the service restart logic in Puppet. OS-specific
#   defaults are provided via Hiera data.
#
# @param nagios_ensure
#   If nagios_manage is true, this controls whether Nagios resources are added
#   or removed. Requires nagios_plugins_dir to be set unless nagios_ensure is
#   set to 'missing' or 'absent'.
#
# @param nagios_manage
#   If false, no Nagios resources are managed.
#
# @param nagios_plugins_dir
#   Location on the system where Nagios plugins typically live. This variable
#   must be set if nagios_manage is true and nagios_ensure is 'present'.
#   Example: /usr/lib64/nagios-plugins on RHEL/CentOS.
#
# @param nagios_link_plugins
#   A list of plugin names that should be symlinked from nagios_plugins_dir
#   into $vardir/InterMapper_Settings/Tools for use by InterMapper probe
#   definitions.
#
# @example Basic usage
#   include intermapper
#
# @example With Nagios integration
#   class { 'intermapper':
#     nagios_manage      => true,
#     nagios_plugins_dir => '/usr/lib64/nagios-plugins',
#   }
#
# @example Custom package and service configuration
#   class { 'intermapper':
#     package_ensure => 'latest',
#     service_ensure => 'running',
#     vardir         => '/opt/intermapper/var',
#   }
#
class intermapper (
  # Required parameters (no defaults)
  Variant[String[1], Array[String[1]]] $package_name,
  String[1] $service_name,
  Array[String[1]] $nagios_link_plugins,
  # Optional parameters (with defaults)
  Stdlib::Absolutepath $basedir                       = '/usr/local',
  Stdlib::Absolutepath $vardir                        = '/var/local',
  String[1] $owner                                     = 'intermapper',
  String[1] $group                                     = 'intermapper',
  String[1] $package_ensure                            = 'present',
  Boolean $package_manage                              = true,
  Optional[String[1]] $package_provider                = undef,
  Optional[String[1]] $package_source                  = undef,
  Boolean $service_manage                              = true,
  Boolean $service_imdc_manage                         = true,
  Boolean $service_imflows_manage                      = true,
  Stdlib::Ensure::Service $service_ensure              = 'running',
  Stdlib::Ensure::Service $service_imdc_ensure         = 'stopped',
  Stdlib::Ensure::Service $service_imflows_ensure      = 'stopped',
  String[1] $service_imdc_name                         = 'imdc',
  String[1] $service_imflows_name                      = 'imflows',
  Optional[String[1]] $service_provider                = undef,
  Optional[String[1]] $service_status_cmd              = undef,
  Boolean $service_has_restart                         = true,
  Enum['present', 'absent', 'missing'] $nagios_ensure = 'present',
  Boolean $nagios_manage                               = false,
  Optional[Stdlib::Absolutepath] $nagios_plugins_dir   = undef,
) {
  if $nagios_manage {
    if $nagios_ensure == 'present' and $nagios_plugins_dir == undef {
      fail(
        'nagios_plugins_dir must be specified when nagios_ensure is "present"'
      )
    }
  }

  $settingsdir = "${vardir}/InterMapper_Settings"
  $toolsdir = "${settingsdir}/Tools"

  contain intermapper::install
  contain intermapper::nagios
  contain intermapper::service
  contain intermapper::service_extra

  Class['intermapper::install']
  -> Class['intermapper::nagios']
  ~> Class['intermapper::service']
  -> Class['intermapper::service_extra']
}
