# Development Container Configuration

This directory contains the configuration for a development container that provides a complete Puppet development environment.

## Container Engine Support

This devcontainer is compatible with both **Docker** and **Podman**.

### Using with Docker

VS Code will automatically detect and use Docker if it's available. No additional configuration is needed.

### Using with Podman

To use this devcontainer with Podman:

1. **Install Podman** on your system
2. **Configure VS Code** to use Podman by adding this to your VS Code settings:
   ```json
   {
     "dev.containers.dockerPath": "podman",
     "dev.containers.dockerComposePath": "podman-compose"
   }
   ```

3. **Start Podman service** (if required on your system):
   ```bash
   systemctl --user start podman.socket
   ```

### Podman-Specific Features

The devcontainer includes several podman-specific optimizations:

- **User namespace mapping** via `--userns=keep-id` to maintain proper file permissions
- **Explicit UID/GID** (1000:1000) for the puppet user to avoid permission issues
- **Removed mount consistency** option (Docker-specific) for better podman compatibility
- **User-install gems** to avoid permission conflicts

## What's Included

- **Puppet Development Kit (PDK)** - Complete Puppet toolchain
- **Ruby & Bundler** - For RSpec testing and gem management
- **Oh My Zsh** - Enhanced shell experience
- **Essential tools**: git, curl, vim, nano, jq
- **Puppet-specific gems**: puppet-lint, rspec-puppet, rubocop, puppet-strings
- **VS Code extensions**: Puppet language support, Ruby, YAML, and more

## Getting Started

1. Open this project in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and start
4. Run `pdk --version` to verify the environment is ready
5. Start developing your Puppet module!

## Common Commands

```bash
# Validate Puppet syntax
pdk validate

# Run RSpec tests
pdk test unit

# Lint Puppet code
pdk validate puppet

# Install gem dependencies
bundle install

# Run specific tests
rspec spec/classes/intermapper_spec.rb
```

## Troubleshooting

### Permission Issues with Podman

If you encounter permission issues:

1. Ensure your user is in the `podman` group
2. Try running with `--privileged` flag in runArgs
3. Check that the workspace directory has proper permissions

### Container Build Fails

If the container fails to build:

1. Check that the base image `puppet/pdk:latest` is accessible
2. Verify your internet connection for downloading packages
3. Try building with `--no-cache` flag

## Customization

You can customize this environment by:

- Modifying `.devcontainer/devcontainer.json` for VS Code settings
- Updating `.devcontainer/Dockerfile` for additional packages
- Adding gems to the project's `Gemfile`