FROM puppet/pdk:latest

# Set environment variables
ENV PUPPET_GEM_VERSION="~> 7.0" \
    FACTER_GEM_VERSION="~> 4.0" \
    DEBIAN_FRONTEND=noninteractive

# Install additional system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    zsh \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3 \
    python3-pip \
    jq \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh for root (needed for template)
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set up PDK environment and install additional Ruby gems
ENV PATH="/opt/puppetlabs/pdk/private/ruby/3.2.5/bin:/opt/puppetlabs/pdk/bin:${PATH}"
RUN gem install \
    puppet-lint \
    rspec-puppet \
    puppetlabs_spec_helper \
    metadata-json-lint \
    puppet-strings \
    rubocop \
    rubocop-performance \
    rubocop-rspec \
    && gem cleanup

# Create puppet user with proper UID/GID for podman compatibility
# Use UID/GID 1000 which is common for regular users
RUN groupadd -g 1000 puppet && \
    useradd -m -u 1000 -g 1000 -s /bin/zsh puppet && \
    echo "puppet ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/puppet/.oh-my-zsh && \
    chown -R puppet:puppet /home/puppet

# Copy Oh My Zsh configuration from root and set up for puppet user
RUN cp -r /root/.oh-my-zsh /home/puppet/.oh-my-zsh && \
    cp /root/.zshrc /home/puppet/.zshrc && \
    chown -R puppet:puppet /home/puppet/.oh-my-zsh /home/puppet/.zshrc

# Set up the workspace with proper permissions
WORKDIR /workspace
RUN chown -R puppet:puppet /workspace

# Switch to puppet user
USER puppet

# Install bundler as puppet user
RUN gem install bundler --user-install

# Expose any ports that might be needed (none for this project)
EXPOSE 8080

# Set the default command
CMD ["/bin/zsh"]