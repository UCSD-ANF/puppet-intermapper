# @summary Install a new SNMP MIB into Intermapper's MIB Files directory.
#
# @param mibname
#   The filename of the MIB File. Usually something like 'fa_40.mib'.
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
define intermapper::mibfile (
  String[1] $mibname          = $title,
  Variant[String[1], Stdlib::Absolutepath] $ensure = 'present',
  Optional[Stdlib::Absolutepath] $target = undef,
  Optional[String[1]] $source            = undef,
  Optional[String] $content              = undef,
  Optional[Boolean] $force               = undef,
  Optional[Stdlib::Filemode] $mode       = undef,
) {
  include 'intermapper'

  $mibdir = "${intermapper::settingsdir}/MIB Files"

  file { "${mibdir}/${mibname}" :
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
