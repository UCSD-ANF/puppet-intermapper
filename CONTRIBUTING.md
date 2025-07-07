# Contributing to puppet-intermapper

We welcome contributions to the puppet-intermapper module! This document outlines the process for contributing and
the standards we expect.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally
3. Create a feature branch from `master`
4. Make your changes
5. Test your changes
6. Submit a pull request

## Development Environment

This module uses the Puppet Development Kit (PDK) for development and testing:

```bash
# Install PDK
# Follow instructions at: https://puppet.com/docs/pdk/latest/pdk_install.html

# Clone the repository
git clone https://github.com/UCSD-ANF/puppet-intermapper.git
cd puppet-intermapper

# Install dependencies
pdk bundle install

# Run tests
pdk test unit

# Run validation
pdk validate
```

## Code Standards

### Puppet Code

- Follow [Puppet Language Style Guide](https://puppet.com/docs/puppet/latest/style_guide.html)
- Use modern Puppet practices (no inheritance, use data-in-modules)
- Add proper data types to all parameters
- Document all classes and defined types using Puppet Strings format

### Documentation

- Use Puppet Strings format for all documentation:
  - `@summary` for brief descriptions
  - `@param` for parameter documentation
  - `@api private` for internal classes/defined types
- Update `CHANGELOG.md` for any user-facing changes
- Update `README.md` if adding new features

### Testing

- All new functionality must include tests
- Maintain 100% test coverage
- All tests must pass before submitting PR
- Add tests for different operating systems if applicable

## Supported Platforms

This module supports:

- RedHat Enterprise Linux 7, 8, 9
- CentOS 7, 8
- Rocky Linux 8, 9
- AlmaLinux 8, 9

## Pull Request Process

1. **Create a descriptive branch name**: `feature/add-new-functionality` or `bugfix/fix-issue-description`

2. **Write good commit messages**:
   - Use imperative mood ("Add feature" not "Added feature")
   - First line should be 50 characters or less
   - Include detailed description if needed

3. **Test your changes**:

   ```bash
   pdk test unit
   pdk validate
   ```

4. **Update documentation**:
   - Update `CHANGELOG.md` with your changes
   - Update `README.md` if adding new parameters or functionality
   - Ensure all Puppet code is properly documented

5. **Submit pull request**:
   - Use a descriptive title
   - Include a detailed description of changes
   - Reference any related issues

## Code Review Process

All submissions require review before merging:

1. Automated tests must pass (GitHub Actions)
2. Code review by maintainers
3. Documentation review
4. Final approval and merge

## Reporting Issues

When reporting issues, please include:

- Puppet version
- Operating system and version
- Module version
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Any relevant log output

## Code of Conduct

This project follows the [Puppet Community Code of Conduct](https://puppet.com/community/code-of-conduct).

## License

By contributing to this project, you agree that your contributions will be licensed under the
BSD 2-Clause License.

## Contact

For questions about contributing, please:

- Open an issue on GitHub
- Contact the maintainers

Thank you for contributing to puppet-intermapper!
