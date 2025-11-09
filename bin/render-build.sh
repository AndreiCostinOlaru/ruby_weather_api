#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Set all database URLs to the same DATABASE_URL
export CACHE_DATABASE_URL=$DATABASE_URL
export QUEUE_DATABASE_URL=$DATABASE_URL
export CABLE_DATABASE_URL=$DATABASE_URL

bundle exec rails db:migrate