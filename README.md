# rails\_activejob\_example

This is a minimalist Rails application created to test background workers on Engine Yard Cloud.

## Usage

### Generate jobs

To generate 100 jobs:

```
ECHO_JOB_COUNT=100 bundle exec rake echo:generate
```

### Switch the ActiveJob backend

DelayedJob, Resque and Sidekiq are already in the Gemfile. To switch the ActiveJob backend, modify `config/application.rb`. Uncomment one backend and comment out the lines for the other backends.

```
config.active_job.queue_adapter = :sidekiq
#config.active_job.queue_adapter = :delayed_job
#config.active_job.queue_adapter = :resque
```


SG ey-ky_demo_application_v5-1593083178-16801-29080

Type|Protocol|Port range|Source|Description - optional
PostgreSQL	TCP	5432	3.208.67.204/32	DEIS JF Postgres port
PostgreSQL	TCP	5432	35.170.23.65/32	DEIS JF Postgres port
Custom TCP	TCP	6379	3.208.67.204/32	DEIS JF Redis port
Custom TCP	TCP	6379	35.170.23.65/32	DEIS JF Redis port



echo 'host    all             deploy          0.0.0.0/0       md5' >> /db/postgresql/9.4/data/pg_hba.conf && echo 'host    ky_demo_application_v5   deploy  0.0.0.0/0       md5' >> /db/postgresql/9.4/data/pg_hba.conf && psql -c "SELECT pg_reload_conf()"








ilias@ilias-LubuntuVM:[~/GitCode/KontainerYard/ky-demo-applications]: deis apps:create demo-eycloud-to-ky-application  --remote=deis-demo-eycloud-to-ky-application
Creating Application... done, created demo-eycloud-to-ky-application
Git remote deis-demo-eycloud-to-ky-application successfully created for app demo-eycloud-to-ky-application.
ilias@ilias-LubuntuVM:[~/GitCode/KontainerYard/ky-demo-applications]: deis apps
=== Apps
demo-eycloud-to-ky-application
ilias-ky-school
ilias-simple-sidekiq
ilias-simple-sidekiq-new
ilias-simple-sshbox
ilias@ilias-LubuntuVM:[~/GitCode/KontainerYard/ky-demo-applications]: git remote -v
deis-demo-eycloud-to-ky-application     ssh://git@deis-builder.jfuechsl-playground.kontaineryard.io:2222/demo-eycloud-to-ky-application.git (fetch)
deis-demo-eycloud-to-ky-application     ssh://git@deis-builder.jfuechsl-playground.kontaineryard.io:2222/demo-eycloud-to-ky-application.git (push)
origin  git@github.com:engineyard/ky-demo-applications.git (fetch)
origin  git@github.com:engineyard/ky-demo-applications.git (push)


deis config:set DOCKER_BUILD_ARGS='{"DEIS_DOCKER_BUILD_ARGS_ENABLED":"1","db_yml_password":"tCgJYEbXKV","db_yml_host":"ec2-3-128-169-212.us-east-2.compute.amazonaws.com"}' RAILS_ENV="production" REDIS_URL="redis://ec2-3-128-169-212.us-east-2.compute.amazonaws.com:6379/0" --app=demo-eycloud-to-ky-application
