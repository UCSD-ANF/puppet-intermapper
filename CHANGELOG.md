# Changelog

All notable changes to this project will be documented in this file.

## Release 2.1.0

### New Features

- Added APT repository management for Debian/Ubuntu systems
- Implemented official InterMapper repository support with GPG key validation
- Added OS-specific Hiera data for Debian/Ubuntu platforms
- Updated directory structures for InterMapper 6.6+ following Linux File System Hierarchy Standard

### Platform Support

- Enhanced Debian/Ubuntu support with native APT repository management
- Added OS detection and platform-specific configuration
- Comprehensive package repository integration with proper dependency ordering

### Directory Structure Updates

- Updated default directories for InterMapper 6.6+ on all platforms:
  - Settings: `/var/opt/helpsystems/intermapper/InterMapper_Settings`
  - Certificates: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Certificates`
  - Sounds: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Sounds`
  - Icons: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Icons`
  - MIB Files: `/var/opt/helpsystems/intermapper/InterMapper_Settings/MIB Files`
  - Probes: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Probes`
  - Tools: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Tools`
  - Extensions: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Extensions`
  - Nagios Plugins: `/var/opt/helpsystems/intermapper/InterMapper_Settings/Tools/Nagios Plugins`

### Dependencies

- Added puppetlabs-apt module dependency (>= 9.0.0, < 10.0.0) for Debian/Ubuntu repository management
- Updated metadata.json with Debian and Ubuntu OS support declarations

### Technical Implementation

- Enhanced [`intermapper::repo`](manifests/repo.pp) class with automatic GPG key management
- Added comprehensive repository configuration with proper key validation
- Implemented OS-specific logic for APT vs YUM repository management
- Updated all define resources to use new directory structure defaults
- Maintained 100% test coverage with updated directory path validation

### Quality Improvements

- All tests pass with 683 examples, 0 failures
- Clean validation with no style or syntax issues
- Comprehensive documentation updates for new features
- Enhanced error handling for repository operations

## Release 2.0.1

### Documentation & Project Infrastructure

- Added comprehensive README.md with complete module documentation
- Added BSD 2-Clause LICENSE file with proper copyright attribution
- Added CONTRIBUTING.md with development guidelines and standards
- Enhanced project structure with proper open source project files
- Fixed Markdown formatting issues and ensured markdownlint compliance
- Added detailed usage examples, parameter documentation, and migration guides
- Updated company references from Help/Systems to Fortra (current owner)

### Improvements

- Complete project documentation overhaul
- Proper legal framework for open source distribution
- Clear contributor guidelines and development standards
- Enhanced user experience with comprehensive examples

### Technical Details

- All documentation passes markdownlint validation
- README.md includes installation, usage, and migration guidance
- CONTRIBUTING.md provides development standards and testing procedures
- LICENSE file ensures proper open source distribution compliance

## Release 2.0.0

### Breaking Changes

- Dropped support for Solaris platform
- Removed deprecated params.pp pattern (replaced with Hiera data)
- Modernized module structure following current Puppet best practices

### Features

- Implemented modern Hiera data hierarchy with OS-specific overrides
- Added comprehensive Puppet-Strings documentation with @summary, @param, @api annotations
- Modernized class containment using `contain` statements instead of anchor resources
- Added proper data types to all parameters and defined types
- Made all helper classes private with assert_private() calls
- Automatic parameter lookup replaces inheritance patterns
- Fixed parameter ordering (required parameters first)

### Quality Improvements

- Clean validation with no warnings or errors
- Maintained 100% test coverage (301 examples, 0 failures)
- Better separation of data and code for improved maintainability
- Focused platform support on Linux distributions (RedHat, CentOS, Rocky, AlmaLinux)

### Implementation Details

- Removed manifests/params.pp entirely
- Data moved to data/common.yaml with defaults
- Updated all spec files to remove Solaris test cases
- Enhanced documentation throughout all manifests
- Modernized defined types with proper typing

## Release 1.2.0

### New Features

- Comprehensive PDK 3.4.0 modernization
- 100% test coverage achievement

### Resolved Issues

### Outstanding Issues

## Release 1.0.1

### Initial Features

### Bug Fixes

### Known Issues
