# puppet-intermapper

[![Build Status](https://github.com/UCSD-ANF/puppet-intermapper/workflows/CI/badge.svg)](https://github.com/UCSD-ANF/puppet-intermapper/actions)
[![Puppet Forge](https://img.shields.io/puppetforge/v/UCSDANF/intermapper.svg)](https://forge.puppet.com/modules/UCSDANF/intermapper)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/UCSDANF/intermapper.svg)](https://forge.puppet.com/modules/UCSDANF/intermapper)

#### Table of Contents

- [puppet-intermapper](#puppet-intermapper)
      - [Table of Contents](#table-of-contents)
  - [Description](#description)
    - [Features](#features)
  - [Setup](#setup)
    - [Requirements](#requirements)
    - [Installation](#installation)
  - [Usage](#usage)
    - [Basic Usage](#basic-usage)
    - [Advanced Configuration](#advanced-configuration)
    - [Nagios Integration](#nagios-integration)
    - [Hiera Configuration](#hiera-configuration)
    - [Custom Resources](#custom-resources)
      - [Managing Custom Probes](#managing-custom-probes)
      - [Managing MIB Files](#managing-mib-files)
      - [Managing Tools](#managing-tools)
  - [Reference](#reference)
    - [Classes](#classes)
      - [`intermapper`](#intermapper)
    - [Defined Types](#defined-types)
  - [Limitations](#limitations)
  - [Development](#development)
    - [Development Requirements](#development-requirements)
    - [Testing](#testing)
    - [Documentation](#documentation)
  - [Release Notes](#release-notes)
    - [Version 2.0.0](#version-200)
  - [Support](#support)
  - [License](#license)

## Description

The puppet-intermapper module manages the InterMapper network monitoring application by Help/Systems. This module handles installation, configuration, and management of InterMapper services, along with integration capabilities for Nagios plugins.

### Features

- **Complete InterMapper lifecycle management**: Install, configure, and manage InterMapper services
- **Multi-service support**: Manage main InterMapper service plus optional DataCenter and Flows services
- **Nagios integration**: Symlink Nagios plugins into InterMapper Tools directory
- **Extensible configuration**: Support for custom probes, icons, MIB files, and tools
- **Modern Puppet practices**: Uses Hiera data hierarchy, proper data types, and current best practices
- **Comprehensive testing**: 100% test coverage with automated validation

## Setup

### Requirements

- **Puppet**: 6.21.0 or later
- **Operating Systems**: 
  - RedHat Enterprise Linux 7, 8, 9
  - CentOS 7, 8
  - Rocky Linux 8, 9
  - AlmaLinux 8, 9

### Installation

Install the module from Puppet Forge:

```bash
puppet module install UCSDANF-intermapper
```

Or add to your Puppetfile:

```ruby
mod 'UCSDANF-intermapper', '2.0.0'
```

## Usage

### Basic Usage

Simple installation with default settings:

```puppet
include intermapper
```

### Advanced Configuration

Full configuration example:

```puppet
class { 'intermapper':
  package_ensure         => 'latest',
  package_name           => 'intermapper',
  service_ensure         => 'running',
  service_imdc_manage    => true,
  service_imdc_ensure    => 'running',
  service_imflows_manage => true,
  service_imflows_ensure => 'running',
  nagios_manage          => true,
  nagios_plugins_dir     => '/usr/lib64/nagios-plugins',
  nagios_link_plugins    => [
    'check_nrpe',
    'check_disk',
    'check_load',
    'check_procs',
  ],
}
```

### Nagios Integration

Enable Nagios plugin integration:

```puppet
class { 'intermapper':
  nagios_manage      => true,
  nagios_plugins_dir => '/usr/lib64/nagios-plugins',
  nagios_link_plugins => [
    'check_nrpe',
    'check_disk',
    'check_file_age',
    'check_procs',
    'check_snmp',
  ],
}
```

This creates symlinks in `/var/local/InterMapper_Settings/Tools/` pointing to the specified Nagios plugins, making them available for use in InterMapper probe definitions.

### Hiera Configuration

Configure via Hiera data:

```yaml
# data/common.yaml
intermapper::package_ensure: 'present'
intermapper::service_ensure: 'running'
intermapper::nagios_manage: true
intermapper::nagios_plugins_dir: '/usr/lib64/nagios-plugins'
intermapper::nagios_link_plugins:
  - 'check_nrpe'
  - 'check_disk'
  - 'check_file_age'
  - 'check_procs'
  - 'check_snmp'
```

### Custom Resources

The module provides defined types for managing InterMapper components:

#### Managing Custom Probes

```puppet
intermapper::probe { 'custom-probe':
  ensure  => 'present',
  content => template('mymodule/custom-probe.tmpl'),
}
```

#### Managing MIB Files

```puppet
intermapper::mibfile { 'custom.mib':
  ensure => 'present',
  source => 'puppet:///modules/mymodule/custom.mib',
}
```

#### Managing Tools

```puppet
intermapper::tool { 'custom-tool':
  ensure => 'present',
  source => 'puppet:///modules/mymodule/custom-tool.sh',
  mode   => '0755',
}
```

## Reference

### Classes

#### `intermapper`

Main class for managing InterMapper.

**Parameters:**

- `package_name` (Variant[String[1], Array[String[1]]]): Package name(s) to install
- `service_name` (String[1]): Name of the main InterMapper service
- `nagios_link_plugins` (Array[String[1]]): List of Nagios plugins to symlink
- `basedir` (Stdlib::Absolutepath): InterMapper installation directory (default: '/usr/local')
- `vardir` (Stdlib::Absolutepath): InterMapper data directory (default: '/var/local')
- `package_ensure` (String[1]): Package ensure state (default: 'present')
- `package_manage` (Boolean): Whether to manage the package (default: true)
- `service_ensure` (Stdlib::Ensure::Service): Service ensure state (default: 'running')
- `service_manage` (Boolean): Whether to manage services (default: true)
- `nagios_manage` (Boolean): Whether to manage Nagios integration (default: false)
- `nagios_plugins_dir` (Optional[Stdlib::Absolutepath]): Path to Nagios plugins directory

For complete parameter documentation, see the generated reference documentation.

### Defined Types

- `intermapper::probe`: Manage InterMapper probe definitions
- `intermapper::mibfile`: Manage SNMP MIB files
- `intermapper::tool`: Manage InterMapper tools
- `intermapper::icon`: Manage custom icons
- `intermapper::nagios_plugin_link`: Create symlinks to Nagios plugins (private)

All defined types are documented with Puppet Strings. Generate documentation with:

```bash
puppet strings generate --format markdown
```

## Limitations

- This module is designed for and tested on RedHat-family operating systems
- InterMapper package must be available in configured repositories
- Nagios integration requires Nagios plugins to be installed separately

## Development

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Requirements

- Puppet Development Kit (PDK) 3.4.0 or later
- Git

### Testing

```bash
# Install dependencies
pdk bundle install

# Run unit tests
pdk test unit

# Run validation
pdk validate

# Run all tests
pdk test unit && pdk validate
```

### Documentation

Generate reference documentation:

```bash
puppet strings generate --format markdown
```

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for detailed release notes.

### Version 2.0.0

This is a major release with breaking changes:

- **Breaking**: Dropped support for Solaris
- **Breaking**: Removed deprecated `params.pp` pattern
- **New**: Modern Hiera data hierarchy
- **New**: Comprehensive Puppet Strings documentation
- **New**: Proper data types throughout
- **Improved**: Modern class containment patterns
- **Improved**: 100% test coverage maintained

For migration guidance from 1.x, see [CHANGELOG.md](CHANGELOG.md).

## Support

- **Issues**: [GitHub Issues](https://github.com/UCSD-ANF/puppet-intermapper/issues)
- **Source**: [GitHub Repository](https://github.com/UCSD-ANF/puppet-intermapper)

## License

BSD 2-Clause License. See [LICENSE](LICENSE) file for details.

---

**Maintained by**: The Regents of the University Of California  
**Author**: Geoff Davis
