# @summary Manages Nagios plugin links for InterMapper
#
# Links Nagios plugins from the main Nagios plugin directory to
# InterMapper's Tools directory for use in probes.
#
# @api private
class intermapper::nagios {
  assert_private()

  if $intermapper::nagios_manage {
    $manage_npdir = $intermapper::nagios_plugins_dir ? {
      'UNSET' => undef,
      default => $intermapper::nagios_plugins_dir,
    }
    intermapper::nagios_plugin_link { $intermapper::nagios_link_plugins:
      ensure             => $intermapper::nagios_ensure,
      nagios_plugins_dir => $manage_npdir,
    }
  }
}
