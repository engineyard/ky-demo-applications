class PagesController < ApplicationController 
  
  def enqueue_jobs
    sjob_type  = request.params["job_type"]
    sjob_count = request.params["job_count"].to_i
    case sjob_type
    when "five_min_delay_job"
      sjob_count.times{ FivemindelayJob.set(queue: :default).perform_later }
    when "echo_job"
      sjob_count.times{ EchoJob.perform_later }
    end
    redirect_to root_path   
  end
    
  def landing
    ps = Sidekiq::ProcessSet.new
      
    total_threads = ps.map { |host| host['concurrency'].to_i }.sum 
    busy_threads = ps.map { |host| host['busy'].to_i }.sum 
    busy_percentage = (100.0 * (busy_threads.to_f / [total_threads, 1].max.to_f)).to_i
      
    @template_variables = {
      "sidekiq" => [
        {
          "key" =>"Total Sidekiq Pods",      
          "value" =>ps.map { |host| 1 }.sum,      
        },
        {
          "key" => "Threads per sidekiq pod",
          "value" => ps.first["concurrency"]
        },
        {
          "key" =>"Total Sidekiq Threads",
          "value" =>total_threads
        },
        {
          "key" =>"Busy Sidekiq Threads",
          "value" =>busy_threads
        } ,
        {
          "key" =>"Busy Percentage",
          "value" =>busy_percentage
        }        
      ],
      "environment" => [
        {
          "key" => "KY_AUTOSCALING_sidekiq_ENABLED",
          "value" =>ENV["KY_AUTOSCALING_sidekiq_ENABLED"],
          "explanation" => "Swith Custom AS on/off"
        },
        {
          "key" => "KY_AUTOSCALING_sidekiq_MIN_REPLICAS",
          "value" =>ENV["KY_AUTOSCALING_sidekiq_MIN_REPLICAS"],
          "explanation" => "The minimum number of pods to scale up to"
        },
        {
          "key" => "KY_AUTOSCALING_sidekiq_MAX_REPLICAS",
          "value" =>ENV["KY_AUTOSCALING_sidekiq_MAX_REPLICAS"],
          "explanation" => "The maximum number of pods to scale up to"
        },
        #{
        #  "key" => "KY_AUTOSCALING_sidekiq_METRIC_NAME",
        #  "value" =>ENV["KY_AUTOSCALING_sidekiq_METRIC_NAME"],
        #  "explanation" => "The metric name"
        #},
        #{
        #  "key" => "KY_AUTOSCALING_sidekiq_METRIC_QUERY",
        #  "value" =>ENV["KY_AUTOSCALING_sidekiq_METRIC_QUERY"],
        #  "explanation" => "The name of the metric to scrap on /metrics"
        #},
        #{
        #  "key" => "KY_AUTOSCALING_sidekiq_METRIC_TYPE",
        #  "value" =>ENV["KY_AUTOSCALING_sidekiq_METRIC_TYPE"],
        #  "explanation" => "The metric type (Resource/Pods/Prometheus)"
        #},
        #{
        #  "key" => "KY_AUTOSCALING_sidekiq_TARGET_TYPE",
        #  "value" =>ENV["KY_AUTOSCALING_sidekiq_TARGET_TYPE"],
        #  "explanation" => "The type of the target (Utilization/Value/AverageValue)"
        #},
        {
          "key" => "KY_AUTOSCALING_sidekiq_TARGET_VALUE",
          "value" =>ENV["KY_AUTOSCALING_sidekiq_TARGET_VALUE"],
          "explanation" => "The threshold (%) for scaling up/down"
        }
        

      ]
          
      
        
    }
  end
    




end