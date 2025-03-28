#!/bin/bash
set -e
set -o errtrace
trap 'echo "Error on line $LINENO: $BASH_COMMAND" && exit 1' ERR

# Explicitly define the Bundler executable path
BUNDLE_CMD="/home/ubuntu/.local/share/gem/ruby/3.2.0/bin/bundle"

# Verify that the Bundler executable exists
if [ ! -x "$BUNDLE_CMD" ]; then
    echo "Error: Bundler not found or not executable at $BUNDLE_CMD"
    exit 1
fi

echo "Using Bundler from: $BUNDLE_CMD"
echo "Starting deployment on EC2 instance..."

# Change into the application directory
cd ContactsManager || { echo "Error: ContactsManager directory not found"; exit 1; }

# Install production dependencies
echo "Installing dependencies..."
"$BUNDLE_CMD" install --deployment --without development test

# Run database migrations
echo "Migrating database..."
"$BUNDLE_CMD" exec rails db:migrate RAILS_ENV=production

# Precompile assets
echo "Precompiling assets..."
"$BUNDLE_CMD" exec rails assets:precompile RAILS_ENV=production

# Restart the application service
echo "Restarting the application service..."
sudo systemctl restart ContactsManager

echo "Deployment complete!"
