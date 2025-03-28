#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Ensure /usr/local/bin is in PATH
export PATH="/usr/local/bin:$PATH"

# Define the absolute path for Bundler
BUNDLE_CMD="/usr/local/bin/bundle"

echo "Starting deployment on EC2 instance..."

# Navigate to the application directory
cd ContactsManager

# Install production dependencies
echo "Installing dependencies..."
$BUNDLE_CMD install --deployment --without development test

# Running database migrations
echo "Migrating database..."
$BUNDLE_CMD exec rails db:migrate RAILS_ENV=production

# Precompile assets
echo "Precompiling assets..."
$BUNDLE_CMD exec rails assets:precompile RAILS_ENV=production

# Restart the application service
echo "Restarting the application service..."
sudo systemctl restart "ContactsManager"

echo "Deployment complete!"
