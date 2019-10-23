Rails.application.config.active_job.queue_adapter = :midget_job
if $0 =~ /rails/ || $0 =~ /puma/
  Rails.application.config.after_initialize do
    MidgetJobs.initialize_workers
  end
end
