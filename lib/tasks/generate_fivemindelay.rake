namespace :fivemindelay do
  desc "Generate Fivemindelay jobs"
  task :generate => :environment do
    job_count = ENV['FIVEMINDELAY_JOB_COUNT'].to_i || 10
    puts "Generating #{job_count} jobs..."
    job_count.times{ FivemindelayJob.perform_later }
  end
end
