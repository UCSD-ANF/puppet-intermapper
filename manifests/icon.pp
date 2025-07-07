# @summary Install a new Intermapper icon into Intermapper's Custom Icons directory.
#
# InterMapper looks in the Custom Icons directory for custom icon files.
#
# @param iconname
#   The filename of the Intermapper Icon. Usually something like 'myicon.png'.
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
define intermapper::icon (
  String[1] $iconname         = $title,
  Variant[String[1], Stdlib::Absolutepath] $ensure = 'present',
  Optional[Stdlib::Absolutepath] $target = undef,
  Optional[String[1]] $source            = undef,
  Optional[String] $content              = undef,
  Optional[Boolean] $force               = undef,
  Optional[Stdlib::Filemode] $mode       = undef,
) {
  include 'intermapper'

  $iconsdir = "${intermapper::settingsdir}/Custom Icons"

  file { "${iconsdir}/${iconname}" :
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
