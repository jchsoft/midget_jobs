Rails.application.config.active_job.queue_adapter = :midget_job
if $0 =~ /rails/ || $0 =~ /puma/
  Rails.application.config.after_initialize do
    Midget::Job.schedule
    MidgetJob.listen_notifications
  end
end

