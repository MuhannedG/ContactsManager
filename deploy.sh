#!/bin/bash

echo "Starting deployment on EC2 instance..."

# Navigate to the application directory
cd ContactsManager

# Install production dependencies
echo "Installing dependencies..."
bundle install --deployment --without development test

# Running database migrations
echo "Migrating database..."
bundle exec rails db:migrate RAILS_ENV=production

# Precompile assets
echo "Precompiling assets..."
bundle exec rails assets:precompile RAILS_ENV=production

# Restart the application service
echo "Restarting the application service..."
sudo systemctl restart "ContactsManager"

echo "Deployment complete!"
