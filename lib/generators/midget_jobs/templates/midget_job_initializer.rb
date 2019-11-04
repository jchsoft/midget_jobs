Rails.application.config.active_job.queue_adapter = :midget_job
Rails.application.config.x.midget_jobs.at_once = 4

if Rails.const_defined? 'Server'
  Rails.application.config.after_initialize do
    MidgetJobs.initialize_workers
  end
end
