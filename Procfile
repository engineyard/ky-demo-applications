web: export DYNO=$HOSTNAME && bundle exec rails server -b 0.0.0.0 -p 5000 -e development 
sidekiq: bundle exec sidekiq -C config/sidekiq.yml -e development  