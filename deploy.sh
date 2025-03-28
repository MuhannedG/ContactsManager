#!/bin/bash
set -e
set -o errtrace
trap 'echo "Error on line $LINENO: $BASH_COMMAND" && exit 1' ERR

echo "=== Installing latest Ruby ==="
# Update package lists and install prerequisites
sudo apt-get update
sudo apt-get install -y software-properties-common

# Add the Brightbox Ruby repository for newer Ruby versions
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update

# Install Ruby 3.2 and development tools
sudo apt-get install -y ruby3.2 ruby3.2-dev build-essential

# Set the system default Ruby to Ruby 3.2
sudo update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby3.2 50
sudo update-alternatives --set ruby /usr/bin/ruby3.2

echo "Ruby version: $(ruby -v)"

echo "=== Installing latest Bundler ==="
# Install the latest Bundler using the gem command from Ruby 3.2
sudo gem install bundler

echo "Bundler version: $(bundle -v)"

echo "=== Starting deployment on EC2 instance ==="

# Change into the application directory
cd ContactsManager || { echo "Error: ContactsManager directory not found"; exit 1; }

# Install production dependencies
echo "Installing dependencies..."
bundle install --deployment --without development test

# Run database migrations
echo "Migrating database..."
bundle exec rails db:migrate RAILS_ENV=production

# Precompile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile RAILS_ENV=production

# Restart the application service
echo "Restarting the application service..."
sudo systemctl restart ContactsManager

echo "Deployment complete!"
