Rails.application.config.active_job.queue_adapter = :midget_job
Rails.application.config.x.midget_jobs.at_once = 4
Rails.application.config.x.midget_jobs.runner = Rails.application.class.module_parent_name

if Rails.const_defined?('Server') || $0.include?('puma')
  Rails.application.config.after_initialize do
    MidgetJobs.initialize_workers
  end
end
