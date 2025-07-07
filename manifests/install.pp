# @summary Manages InterMapper package installation
# @api private
class intermapper::install {
  assert_private()

  if $intermapper::package_manage {
    package { $intermapper::package_name:
      ensure   => $intermapper::package_ensure,
      source   => $intermapper::package_source,
      provider => $intermapper::package_provider,
    }
  }
}
