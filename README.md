# Sidekiq demo application

This is a minimalist Rails application created to test sidekiq workers on KontainerYard. This application is based on [engineyard/rails_activejob_example](https://github.com/engineyard/rails_activejob_example).

## Deployment

The following steps are needed in order to create a new KontainerYard application named `demo-app` and deploy the code in this branch.

1. create a new application: `deis apps:create demo-app --remote=demo-app`
2. configure the application's backing services (`database` and `redis`): `deis config:set REDIS_URL="redis://ec2-18-188-153-124.us-east-2.compute.amazonaws.com:6379/0" DATABASE_URL="postgresql://deploy:OPs8KBt1oH@ec2-18-188-153-124.us-east-2.compute.amazonaws.com"  demo-app --remote=demo-app`
3. deploy the code: `git push demo-app sidekiq`
4. check if the required `web` and `sidekiq` processes (pods) are up and running: `deis ps:list --app=demo-app`
5. if there is no `web` process present issue: `deis scale web=1 --app=demo-app`
6. if there is no `sidekiq` process present issue: `deis scale sidekiq=1 --app=demo-app`
7. get the url of the application: `deis info --app=ilias-simple-sidekiq-new | grep url`
8. you may visit the route `/sidekiq` to see the sidekiq's dashboard

### Generate jobs

To generate some background jobs you may issue:

```
deis run "ECHO_JOB_COUNT=100 bundle exec rake echo:generate" --app=demo-app
deis run "COMPLEX_JOB_COUNT=150 bundle exec rake complex:generate" --app=demo-app
deis run "MEMCRASHER_JOB_COUNT=2 bundle exec rake memcrash:generate" --app=demo-app
deis run "CPUCRASHER_JOB_COUNT=2 bundle exec rake cpucrash:generate" --app=demo-app
```

where the `memcrash` and `cpucrash` jobs will create high memory and cpu usage.


