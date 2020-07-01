namespace :apptask do
  desc "Generate Price Randomizer Job"
  task :generate => :environment do
    job_count = ENV['RANDOMIZER_JOB_COUNT'].to_i || 1
    puts "Generating #{job_count} Price Randomizer Jobs..."
    job_count.times{ RandomizePricesWorker.perform_async }
  end
end