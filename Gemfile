# frozen_string_literal: true

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  git_url_regex = %r{\A(?<url>(https?|git)[:@][^#]*)(#(?<branch>.*))?}
  file_url_regex = %r{\Afile:\/\/(?<path>.*)}

  if place_or_version && (git_url = place_or_version.match(git_url_regex))
    [fake_version, { git: git_url[:url], branch: git_url[:branch], require: false }].compact
  elsif place_or_version && (file_url = place_or_version.match(file_url_regex))
    ['>= 0', { path: File.expand_path(file_url[:path]), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :development do
  gem "fast_gettext", require: false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.1.0')
  gem "json_pure", '<= 2.0.1', require: false if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0.0')
  gem "json", '= 1.8.1', require: false if Gem::Version.new(RUBY_VERSION.dup) == Gem::Version.new('2.1.9')
  gem "json", '= 2.0.4', require: false if Gem::Requirement.create('~> 2.4.2').satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.1.0', require: false if Gem::Requirement.create(['>= 2.5.0', '< 2.7.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "rb-readline", '= 0.5.5', require: false, platforms: [:mswin, :mingw, :x64_mingw]
  
  # Modern PDK dependencies
  gem "puppetlabs_spec_helper", "~> 7.0", require: false
  gem "rspec-puppet", "~> 4.0", require: false
  gem "rspec-puppet-facts", "~> 5.0", require: false
  gem "puppet-lint", "~> 4.0", require: false
  gem "puppet-syntax", "~> 4.0", require: false
  gem "rubocop", "~> 1.50", require: false
  gem "rubocop-rspec", "~> 2.20", require: false
  gem "rubocop-performance", "~> 1.17", require: false
  gem "metadata-json-lint", "~> 4.0", require: false
  
  # Additional development gems
  gem "simplecov", "~> 0.22", require: false
  gem "simplecov-console", "~> 0.9", require: false
  gem "parallel_tests", "~> 4.0", require: false
end

puppet_version = ENV['PUPPET_GEM_VERSION']
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version = ENV['HIERA_GEM_VERSION']

gems = {}

gems['puppet'] = location_for(puppet_version)

# If facter or hiera versions have been specified via the environment
# variables
gems['facter'] = location_for(facter_version) if facter_version
gems['hiera'] = location_for(hiera_version) if hiera_version

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end

# vim: syntax=ruby
