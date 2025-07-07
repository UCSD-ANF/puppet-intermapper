# @summary Symlink a Nagios probe into the Intermapper Tools directory.
#
# Symlink a Nagios probe into the Intermapper Tools directory for use by a
# Intermapper probe definition without having to manage the probe definition's
# path.
#
# Links are managed in the directory:
#   $intermapper::vardir/InterMapper_Settings/Tools
#
# @param nagios_plugins_dir
#   The directory containing the Nagios probe script.
#   Usually something like /usr/lib64/nagios-plugins on RedHat.
#
# @param ensure
#   Remove the link if 'absent' or 'missing', create it otherwise.
#
# @api private
#
define intermapper::nagios_plugin_link (
  Optional[Stdlib::Absolutepath] $nagios_plugins_dir = undef,
  Enum['present', 'absent', 'missing', 'link'] $ensure = 'present',
) {
  $manage_ensure = $ensure ? {
    'absent'  => 'absent',
    'missing' => 'absent',
    'present' => 'link',
    default   => 'link',
  }

  $manage_target = $manage_ensure ? {
    'link'  => "${nagios_plugins_dir}/${name}",
    default => undef,
  }

  intermapper::tool { $name:
    ensure => $manage_ensure,
    target => $manage_target,
  }
}
