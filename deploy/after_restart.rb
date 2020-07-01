on_app_master() do
  sudo "monit stop all -g #{config.app}_sidekiq"
  worker_count = 1 # change as needed
  (0...worker_count).each do |i|
    sudo "monit stop  -g #{config.app}_sidekiq"
    sleep 10
    sudo "monit start  -g #{config.app}_sidekiq"
  end
end


 