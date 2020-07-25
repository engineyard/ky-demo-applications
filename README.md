# VUC demo application

A Rails application created to test sidekiq workers on KY.


### custom Autoscaling
This is a KontainerYard feature. The custom Autoscaling context refers to pods. We can set custom rules in order to decide the scaling of the pods. We start by exposing a `/metrics` route that outputs the needed metrics (e.g. sidekiq workers and queue size). Prometheus will scrape the `/metrics` route of the application and decide on if the pods need scaling or not. Setting the appropriate configuration is more complicated compared to `deis autoscale`, but gives more control.

Although the `/metrics` route could be part of the application, in this example we have decided to create a [mountable rails engine](https://guides.rubyonrails.org/engines.html). This means that we can separate the KontainerYard only components. In this example, the directory `ky_metrics` is the one holding the mountable rails engine that exposes the `/metrics` route. In order to show the great flexibility of the application, we have added the needed "hooks" in the `Dockerfile`. These "hooks" will actually modify the `Gemfile` and `config/routes.rb` in order to include the `ky_metrics` in `Gemfile` and expose `/metrics` in `config/routes.rb`. While we could simply make it part of the application in the first place, this option shows how the `Dockerfile` can be used in order to customize the deployment and also the application itself.  

In our example the `/metrics` route will expose the following information:

```
      metrics = {
        "sidekiq" => { "total_workers" => 0, "total_threads" => 0, "busy_threads" => 0, "busy_percentage" => 0.0}
      }   
```
This means that we are able to create some business rules for the scaling to be based upon (e.g. scale the sidekiq pods when the `busy_percentage` is more than 70%). Since sidekiq shares all the information in redis, these metrics can be easily computed.

In order to set the custom Autoscaling we need to configure the application like:

```
KY_AUTOSCALING_sidekiq_ENABLED              true
KY_AUTOSCALING_sidekiq_MAX_REPLICAS         8
KY_AUTOSCALING_sidekiq_METRIC_NAME          sidekiq_busy_percentage
KY_AUTOSCALING_sidekiq_METRIC_QUERY         sidekiq_busy_percentage
KY_AUTOSCALING_sidekiq_METRIC_TYPE          Prometheus
KY_AUTOSCALING_sidekiq_MIN_REPLICAS         1
KY_AUTOSCALING_sidekiq_TARGET_TYPE          Value
KY_AUTOSCALING_sidekiq_TARGET_VALUE         75
```

