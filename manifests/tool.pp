# @summary Install a new Intermapper tool into Intermapper's Tools directory.
#
# InterMapper looks in the Tools directory for scripts if the path isn't
# set in the probe definition. This is also a good place to put libraries that
# probes may need.
#
# @param toolname
#   The filename of the Intermapper Tool. Usually
#   something like 'edu.ucsd.antelope.check_q330' or 'nagios_q330_ping'.
#
# @param ensure
#   Works just like a file resource.
#
# @param target
#   If ensure is set to link, then target is used as the target parameter
#   for the underlying file resource. This attribute is mutually exclusive with
#   source and content.
#
# @param source
#   The source for the file, as a Puppet resource path. This attribute is
#   mutually exclusive with content and target.
#
# @param content
#   The desired contents of a file, as a string. This attribute is mutually
#   exclusive with source and target.
#
# @param force
#   Force the file operation if target exists.
#
# @param mode
#   File mode, same format as a file resource.
#
# @api private
#
define intermapper::tool (
  String[1] $toolname         = $title,
  Variant[String[1], Stdlib::Absolutepath] $ensure = 'present',
  Optional[Stdlib::Absolutepath] $target = undef,
  Optional[String[1]] $source            = undef,
  Optional[String] $content              = undef,
  Optional[Boolean] $force               = undef,
  Optional[Stdlib::Filemode] $mode       = undef,
) {
  include 'intermapper'

  $toolsdir = "${intermapper::settingsdir}/Tools"

  file { "${toolsdir}/${toolname}" :
    ensure  => $ensure,
    target  => $target,
    source  => $source,
    content => $content,
    force   => $force,
    mode    => $mode,
    owner   => $intermapper::owner,
    group   => $intermapper::group,
    require => Class['intermapper::install'],
    notify  => Class['intermapper::service'],
  }
}
