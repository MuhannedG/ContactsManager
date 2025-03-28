#!/usr/bin/env bash
# Update package lists and install prerequisites
sudo apt update && sudo apt install -y curl gnupg2 build-essential

# Install RVM (if not already installed), latest Ruby, and Bundler
if ! command -v ruby >/dev/null 2>&1; then
  echo "Ruby not found. Installing RVM and the latest Ruby..."
  # Install RVM (single-user install)
  curl -sSL https://get.rvm.io | bash -s stable
  # Load RVM into the current session
  source "$HOME/.rvm/scripts/rvm"
  # Install the latest Ruby and set it as default
  rvm install ruby --latest
  rvm use ruby --default
else
  echo "Ruby is installed: $(ruby -v)"
fi

if ! command -v bundle >/dev/null 2>&1; then
  echo "Bundler not found. Installing Bundler..."
  gem install bundler
else
  echo "Bundler is installed: $(bundle -v)"
fi

# Stop any running instance of the Rails application service (adjust service name)
sudo systemctl stop ContactsManager

# Change directory into the folder where the application is downloaded
cd ContactsManager/ || { echo "Error: ContactsManager directory not found"; exit 1; }

# Install application dependencies
bundle install --deployment --without development test

# Run database migrations
bundle exec rails db:migrate RAILS_ENV=production

# Precompile assets
bundle exec rails assets:precompile RAILS_ENV=production

# Start the application service
sudo systemctl start ContactsManager

echo "Deployment complete!"
