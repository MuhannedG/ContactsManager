#!/usr/bin/env bash

# Update package lists and install prerequisites
sudo apt update && sudo apt install -y curl build-essential

# Stop any running instance of the Rails application (adjust service name as needed)
sudo systemctl stop ContactsManager || echo "ContactsManager service not running, continuing..."

# Change directory into the folder where the Rails application is located
cd ContactsManager/ || { echo "Error: ContactsManager directory not found"; exit 1; }

# Install application dependencies using Bundler
bundle install --deployment --without development test

# Run database migrations
bundle exec rails db:migrate RAILS_ENV=production

# Precompile Rails assets
bundle exec rails assets:precompile RAILS_ENV=production

# Start the Rails application service
sudo systemctl start ContactsManager

echo "Deployment complete!"
