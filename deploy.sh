#!/bin/bash
set -e                   # Exit immediately if a command fails
set -o errtrace          # Ensure the ERR trap is inherited by functions and subshells
trap 'echo "Error on line $LINENO: $BASH_COMMAND" && exit 1' ERR

# Add the user gem bin directory and /usr/local/bin to the PATH
export PATH="/home/ubuntu/.local/share/gem/ruby/3.2.0/bin:/usr/local/bin:$PATH"

echo "Starting deployment on EC2 instance..."

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
