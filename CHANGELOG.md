# Changelog

All notable changes to this project will be documented in this file.

## Release 2.0.0

**Breaking Changes**
- Dropped support for Solaris platform
- Removed deprecated params.pp pattern (replaced with Hiera data)
- Modernized module structure following current Puppet best practices

**Features**
- Implemented modern Hiera data hierarchy with OS-specific overrides
- Added comprehensive Puppet-Strings documentation with @summary, @param, @api annotations
- Modernized class containment using `contain` statements instead of anchor resources
- Added proper data types to all parameters and defined types
- Made all helper classes private with assert_private() calls
- Automatic parameter lookup replaces inheritance patterns
- Fixed parameter ordering (required parameters first)

**Improvements**
- Clean validation with no warnings or errors
- Maintained 100% test coverage (301 examples, 0 failures)
- Better separation of data and code for improved maintainability
- Focused platform support on Linux distributions (RedHat, CentOS, Rocky, AlmaLinux)

**Technical Details**
- Removed manifests/params.pp entirely
- Data moved to data/common.yaml with defaults
- Updated all spec files to remove Solaris test cases
- Enhanced documentation throughout all manifests
- Modernized defined types with proper typing

## Release 1.2.0

**Features**
- Comprehensive PDK 3.4.0 modernization
- 100% test coverage achievement

**Bugfixes**

**Known Issues**

## Release 1.0.1

**Features**

**Bugfixes**

**Known Issues**
