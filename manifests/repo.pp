# @summary Manages InterMapper package repository
#
# This class manages the InterMapper package repository for Debian-based systems.
# It automatically configures the official Fortra repository with GPG key validation
# and ensures proper package ordering with repository updates.
#
# @api private
class intermapper::repo {
  assert_private()

  if $intermapper::repo_manage {
    case $facts['os']['family'] {
      'Debian': {
        # Ensure apt module is available
        if !defined(Class['apt']) {
          include apt
        }

        # InterMapper's official repository uses "/" as the release
        # due to its flat repository structure
        $release = $intermapper::repo_release ? {
          undef   => '/',
          default => $intermapper::repo_release,
        }

        # Configure GPG key for repository validation
        # Supports both key ID and key source URL methods
        if $intermapper::repo_key_source {
          $key_config = {
            'name'   => 'intermapper-release-key',
            'source' => $intermapper::repo_key_source,
          }
        } elsif $intermapper::repo_key {
          $key_config = {
            'id' => $intermapper::repo_key,
          }
        } else {
          $key_config = undef
        }

        # Configure APT repository with proper key validation
        apt::source { 'intermapper':
          ensure   => $intermapper::repo_ensure,
          location => $intermapper::repo_url,
          release  => $release,
          repos    => $intermapper::repo_repos,
          key      => $key_config,
        }

        # Ensure repository is configured and apt cache is updated
        # before any InterMapper packages are installed
        Apt::Source['intermapper'] -> Exec['apt_update'] -> Package<| tag == 'intermapper' |>
      }
      default: {
        # Repository management is only supported on Debian-based systems
        # Other systems should use manual package installation
        if $intermapper::repo_ensure == 'present' {
          warning("Repository management is only supported on Debian-based systems, not ${facts['os']['family']}")
        }
      }
    }
  }
}
