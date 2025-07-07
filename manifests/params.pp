class intermapper::params {
  $package_name = $facts['os']['family'] ? {
    'Solaris' => 'DARTinter',
    default   => 'InterMapper',
  }

  $package_provider = $facts['os']['family'] ? {
    'Solaris' => 'sun',
    default   => undef,
  }

  $service_name = 'intermapperd'

  $service_provider = $facts['os']['family'] ? {
    'Solaris' => 'init',
    default   => undef,
  }

  $service_status_cmd = $facts['os']['family'] ? {
    'Solaris' => "/usr/bin/pgrep ${service_name}",
    default   => undef,
  }

  $service_has_restart = $facts['os']['family'] ? {
    'Solaris' => false,
    default   => true,
  }

  $nagios_link_plugins = [
    'check_nrpe',
    'check_disk',
    'check_file_age',
    'check_icmp',
    'check_mailq',
    'check_tcp',
    'check_udp',
    'check_ftp',
    'check_procs',
    'check_snmp',
  ]
}
