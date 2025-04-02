#!/usr/bin/env bash

# Debug: Show the HOME variable
echo "HOME is set to: $HOME"

# Optionally force the correct HOME (if you know it should be /home/ubuntu)
export HOME=/home/ubuntu

# Update package lists and install prerequisites
sudo apt update && sudo apt install -y curl build-essential

# Source RVM to ensure Ruby and gem commands are available
source "$HOME/.rvm/scripts/rvm" || { echo "RVM not found in $HOME/.rvm/scripts/rvm"; exit 1; }

# Verify Bundler is installed, if not, install it
if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler not found. Installing Bundler..."
  gem install bundler
else
  echo "Bundler is installed: $(bundle -v)"
fi

# Stop the running instance of ContactsManager service (adjust for your init system)
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl stop ContactsManager || echo "ContactsManager service not running, continuing..."
else
  echo "systemctl not found, please stop the ContactsManager process manually if required."
fi

# Change directory into the folder where the application is located
cd ContactsManager/ || { echo "Error: ContactsManager directory not found"; exit 1; }

# Install application dependencies using Bundler
bundle install --deployment --without development test

# Run database migrations
bundle exec rails db:migrate RAILS_ENV=production

# Precompile Rails assets
bundle exec rails assets:precompile RAILS_ENV=production

# Start the Rails application service (adjust for your environment)
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl start ContactsManager
else
  echo "systemctl not available. Please start ContactsManager manually."
fi

echo "Deployment complete!"

