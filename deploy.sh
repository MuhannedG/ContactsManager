#!/bin/bash
set -e
set -o errtrace
trap 'echo "Error on line $LINENO: $BASH_COMMAND" && exit 1' ERR

echo "=== Checking for Ruby installation ==="
if ! command -v ruby >/dev/null 2>&1; then
  echo "Ruby not found. Installing Ruby..."
  sudo apt-get update
  sudo apt-get install -y ruby-full build-essential
else
  echo "Ruby is installed: $(ruby -v)"
fi

echo "=== Checking for Bundler installation ==="
if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler not found. Installing Bundler..."
  sudo gem install bundler
else
  echo "Bundler is installed: $(bundle -v)"
fi

echo "=== Starting deployment on EC2 instance ==="

# Change to the application directory
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
