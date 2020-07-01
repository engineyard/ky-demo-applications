FROM ruby:2.5-alpine
RUN apk update && apk add nodejs build-base libxml2-dev libxslt-dev postgresql postgresql-dev sqlite sqlite-dev busybox-suid curl bash linux-headers



# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /app 
WORKDIR /app


ARG RAILS_ENV
# Copy the main application.
COPY . ./
RUN gem install bundler -v '1.16.3' && bundle install --without development test --jobs 20 --retry 5

# Test that the database.yml works as expected
ARG db_yml_password
ARG db_yml_host
ARG SECRET_KEY_BASE
RUN erb -T - ./ky-specific/config/database.yml.erb > config/database.yml
RUN bundle exec rake db:migrate:status

# Make the migration script runable
RUN chmod +x ky-specific/migration/db-migrate.sh 

# Precompile Rails assets
RUN bundle exec rake assets:precompile



# Expose port 5000 to the Docker host, so we can access it 
# from the outside. This is the same as the one set with
# `deis config:set PORT 5000`
EXPOSE 5000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
#CMD bundle exec sidekiq -C config/sidekiq.yml -e development & bundle exec rails server -b 0.0.0.0 -p 5000 -e development  
CMD sleep 3600