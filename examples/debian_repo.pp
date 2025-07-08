# Example: Basic usage with official repository management on Debian/Ubuntu
class { 'intermapper':
  repo_manage => true,
}

# Example: Repository management with package and service configuration
class { 'intermapper':
  repo_manage    => true,
  package_ensure => 'latest',
  service_ensure => 'running',
}

# Example: Custom repository configuration (if needed for non-standard setups)
class { 'intermapper':
  repo_manage     => true,
  repo_url        => 'https://hsdownloads.helpsystems.com/intermapper/debian',
  repo_key_source => 'https://hsdownloads.helpsystems.com/intermapper/debian/fortra-release-public.asc',
  repo_release    => '/',
  repo_repos      => 'main',
  package_ensure  => 'latest',
  service_ensure  => 'running',
}
