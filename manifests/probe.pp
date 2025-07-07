# @summary Install a new Intermapper probe into Intermapper's Probes directory.
#
# @param probename
#   The filename of the Intermapper Probe definition. Usually
#   something like 'edu.ucsd.antelope.check_q330'.
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
define intermapper::probe (
  String[1] $probename        = $title,
  Variant[String[1], Stdlib::Absolutepath] $ensure = 'present',
  Optional[Stdlib::Absolutepath] $target = undef,
  Optional[String[1]] $source            = undef,
  Optional[String] $content              = undef,
  Optional[Boolean] $force               = undef,
  Optional[Stdlib::Filemode] $mode       = undef,
) {
  include 'intermapper'

  $probedir = "${intermapper::settingsdir}/Probes"

  file { "${probedir}/${probename}" :
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
