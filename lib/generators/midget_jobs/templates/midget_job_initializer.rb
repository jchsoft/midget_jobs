Rails.application.config.active_job.queue_adapter = :midget_job
Rails.application.config.x.midget_jobs.at_once = 4

if $0 =~ /rails/ || $0 =~ /puma/
  Rails.application.config.after_initialize do
    MidgetJobs.initialize_workers
  end
end
