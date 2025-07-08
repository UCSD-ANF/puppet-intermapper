# @summary Manages InterMapper package repository
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

        # Determine release if not specified
        # Note: InterMapper's official repository uses "/" as the release
        $release = $intermapper::repo_release ? {
          undef   => '/',
          default => $intermapper::repo_release,
        }

        # Determine key configuration
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

        # Manage repository
        apt::source { 'intermapper':
          ensure   => $intermapper::repo_ensure,
          location => $intermapper::repo_url,
          release  => $release,
          repos    => $intermapper::repo_repos,
          key      => $key_config,
        }

        # Update apt cache before installing packages
        Apt::Source['intermapper'] -> Exec['apt_update'] -> Package<| tag == 'intermapper' |>
      }
      default: {
        # Repository management only supported on Debian-based systems
        if $intermapper::repo_ensure == 'present' {
          warning("Repository management is only supported on Debian-based systems, not ${facts['os']['family']}")
        }
      }
    }
  }
}
