#!/user/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assests:precompile
bundle exec rake assests:clean
bundle exec rake db:migrate