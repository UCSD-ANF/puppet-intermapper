class intermapper::params {

  $basedir = $::osfamily ? {
    'Solaris' => '/opt/intermapper',
    default   => '/usr/local',
  }

  $settingsdir = $::osfamily ? {
    'Solaris' => '/opt/intermapper/InterMapper_Settings',
    default   => '/var/local/InterMapper_Settings',
  }

  $package_name = $::osfamily ? {
    'Solaris' => 'DARTinter',
    default   => 'InterMapper',
  }

  $package_provider = $::osfamily ? {
    'Solaris' => 'sun',
    default   => undef,
  }

  $service_name = $::osfamily ? {
    default   => 'intermapperd',
  }

  $service_provider = $::osfamily ? {
    'Solaris' => 'init',
    default   => undef,
  }

  $service_status_cmd = $::osfamily ? {
    'Solaris' => '/bin/pgrep',
    default   => undef,
  }

  $toolsdir = "$basedir/Tools"

  $dc_package_name = $::osfamily ? {
    default => 'InterMapper-DataCenter',
  }
}
