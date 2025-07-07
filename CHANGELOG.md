# Changelog

All notable changes to this project will be documented in this file.

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
