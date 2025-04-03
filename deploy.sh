#!/usr/bin/env bash

echo "Running as: $(whoami)"
echo "HOME is: $HOME"
echo "PATH is: $PATH"

# Update system packages
sudo apt update && sudo apt install -y curl build-essential

# Source RVM
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
else
  echo "Error: RVM not found in $HOME/.rvm/scripts/rvm"
  exit 1
fi

# Verify Bundler is installed; install if missing
if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler not found. Installing Bundler..."
  gem install bundler
else
  echo "Bundler is installed: $(bundle -v)"
fi

# Stop the Rails service if running (using systemd)
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl stop contacts_manager || echo "Service not running, continuing..."
fi

# Change directory to the application folder
cd /home/ubuntu/ContactsManager || { echo "ContactsManager directory not found"; exit 1; }

# Install dependencies, run migrations, and precompile assets
bundle install --deployment --without development test
bundle exec rails db:migrate RAILS_ENV=production
bundle exec rails assets:precompile RAILS_ENV=production

# Restart the service
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl start contacts_manager
else
  echo "systemctl not available; please start the service manually."
fi

echo "Deployment complete!"
