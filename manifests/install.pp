# @summary Manages InterMapper package installation
#
# This class handles the installation of InterMapper packages with proper
# dependency ordering and tagging for repository management integration.
#
# @api private
class intermapper::install {
  assert_private()

  if $intermapper::package_manage {
    # Install InterMapper package with proper tagging for repository ordering
    package { $intermapper::package_name:
      ensure   => $intermapper::package_ensure,
      source   => $intermapper::package_source,
      provider => $intermapper::package_provider,
      tag      => 'intermapper',
    }
  }
}
