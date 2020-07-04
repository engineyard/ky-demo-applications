# Demo application that works on both EYCloud and KY

## Introduction

This demo spree application is designed to show how an existing application deployed on EYCloud can also be deployed on KontainerYard, without changing the application code.

## Application Components

The application consists of: 
* the spree code
* a background task named `RandomizePricesWorker`

We have selected `sidekiq` to run the tasks. The task `RandomizePricesWorker` updates the prices of the products in a random manner. 

## Required resources

The application will need a database and redis for sidekiq. These resources are packed in a `solo` instance. 

### EYCloud

In the EYCloud case the resources are accessible since the application code and the services (database + redis) do run in the same instance.

### KontainerYard

In the KontainerYard case the resources should be the same database and redis, like above. In order to access those resources, we need some configuration.


## Configuration

### EYCloud environment

The EYCloud environment is basically a stack v5 one with details:

* `Rails Environment` = `production`
* `Application Server Stack` = `Passenger 5`
* `Stack` = `stable-v5 3.0`
* `Runtime` = `Ruby 2.5`
* `RubyGems` = `Built-in`
* `Database Stack` = `PostgreSQL 9.4.x`

We will need to setup `sidekiq` and `redis` through chef custom recipes.


### Backing services

In order for the KontainerYard application to access the EYCloud resources we need the following:

* open the ports 5432 and 6379 in the Security Group of the EYCloud environment. These ports should be opened for the IPs of the NAT Gateways of the KontainerYard cluster. 
* allow access to PostgreSQL

```
echo 'host    all             deploy          0.0.0.0/0       md5' >> /db/postgresql/9.4/data/pg_hba.conf  >> /db/postgresql/9.4/data/pg_hba.conf && psql -c
```


### EYCloud Environment variables

We will need to set the following environment variables:

* `SECRET_KEY_BASE` = `bdeed967149ca5ec277b16e17ef5b00b739feca6e7b40cf1973a6a071ad967dbc83e43f2ffc1ca8d411bcae355346cd5069ec1304a81a6746cf64b65477cf073`
* `EYCLOUDORKY` = `EYCloud`

### KontainerYard Environment variables

We will need to set the following environment variables:

```
DOCKER_BUILD_ARGS      {"DEIS_DOCKER_BUILD_ARGS_ENABLED":"1","db_yml_password":"tCgJYEbXKV","db_yml_host":"ec2-3-128-169-212.us-east-2.compute.amazonaws.com", "RAILS_ENV":"production", "SECRET_KEY_BASE":"bdeed967149ca5ec277b16e17ef5b00b739feca6e7b40cf1973a6a071ad967dbc83e43f2ffc1ca8d411bcae355346cd5069ec1304a81a6746cf64b65477cf073"}
EYCLOUDORKY            KontainerYard
RAILS_ENV              production
REDIS_URL              redis://ec2-3-128-169-212.us-east-2.compute.amazonaws.com:6379/0
SECRET_KEY_BASE        bdeed967149ca5ec277b16e17ef5b00b739feca6e7b40cf1973a6a071ad967dbc83e43f2ffc1ca8d411bcae355346cd5069ec1304a81a6746cf64b65477cf073
```

The `DOCKER_BUILD_ARGS` are variables that will be available during the docker build stage. These will be used via the `ARG` in Dockerfile in order to pass into the `ky-specific/config/database.yml.erb` template. The values of `db_yml_host` and `db_yml_host` were taken from the EYCloud relevant `database.yml` file. The `REDIS_URL` can be used via rails and sidekiq in order to locate the redis database. 


## Deploy the application

### EYCloud deployment 
Just click the Deploy button 

## Initialize the application

The spree application has some migrations and test data which will populate the database. We can login to the EYCloud instance and run:

```
07:33:11 3.128.169.212 (/data/ky_demo_applications/current)  >  >
*1*[deploy@ip-10-0-0-59]:pts/0$ . /data/ky_demo_applications/shared/config/env.cloud && bundle exec rails g spree:install --migrate=true --seed=true
```

Now the test data are in place. 

## Test that the same code runs on both EYCloud and KontainerYard

Just deploy on EYCloud the branch `bilateral-eycloud-ky` and issue a `git push <your_remote_here> bilateral-eycloud-ky` in order to deploy on KontainerYard. By visiting the application on both ends e.g.:

* EYCloud:        http://ec2-3-128-169-212.us-east-2.compute.amazonaws.com/
* KontainerYard:  http://demo-eycloud-to-ky-application.jfuechsl-playground.kontaineryard.io/

you will seee that the REF is the same, since they run the same code.

You may also see that sidekiq workers run from both deployments by visiting e.g.:

* EYCloud:        http://ec2-3-128-169-212.us-east-2.compute.amazonaws.com/sidekiq
* KontainerYard:  http://demo-eycloud-to-ky-application.jfuechsl-playground.kontaineryard.io/sidekiq

You can also create some jobs to be exeuted via the sidekiq workers:

* EYCloud:              

```
11:49:27 3.128.169.212 (/data/ky_demo_applications/current)  >  >
*130*[deploy@ip-10-0-0-59]:pts/0$ cd /data/ky_demo_applications/current/

11:49:33 3.128.169.212 (/data/ky_demo_applications/current)  >  >
***[deploy@ip-10-0-0-59]:pts/0$ . /data/ky_demo_applications/shared/config/env.cloud &&  RANDOMIZER_JOB_COUNT=3 bundle exec rake apptask:generate

```
* KontainerYard:

```
deis run "RANDOMIZER_JOB_COUNT=3 bundle exec rake apptask:generate" --app=demo-eycloud-to-ky-application
```

Now if you visit the application you will see that the proces have been randomly changed.

