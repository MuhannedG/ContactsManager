#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Ensure the user gem bin directory and /usr/local/bin are in PATH
export PATH="/home/ubuntu/.local/share/gem/ruby/3.2.0/bin:/usr/local/bin:$PATH"

# Dynamically locate Bundler in the PATH
BUNDLE_CMD=$(which bundle)
if [ -z "$BUNDLE_CMD" ]; then
  echo "Error: Bundler not found in PATH. Please install Bundler."
  exit 1
fi

echo "Using Bundler from: $BUNDLE_CMD"
echo "Starting deployment on EC2 instance..."

# Navigate to the application directory
cd ContactsManager || { echo "Error: ContactsManager directory not found"; exit 1; }

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

