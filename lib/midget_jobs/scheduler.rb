module MidgetJobs
  class Scheduler
    def call
      Rails.logger.info "#{self.class.name} starting"
      @thread = Thread.new do
        Rails.logger.info "#{self.class.name} started and waiting for jobs"
        loop do
          sleep_till_next_job
          process_available_jobs
        end
      end
      @thread.abort_on_exception = true
      self
    end

    def wakeup!
      @thread.wakeup
    end

    private

    def process_available_jobs
      MidgetJob.transaction do
        MidgetJob.for_processing.limit(Rails.configuration.x.midget_jobs.at_once).lock("FOR UPDATE SKIP LOCKED").each do |midget_job|
          Rails.logger.info "#{self.class.name} firing midget_job: #{midget_job.id}"
          midget_job.fire_thread
          midget_job.destroy!
        end
      end
    end

    # interval till next job or 0 if there is no job - meaning sleep for ever or till wakeup
    def sleep_till_next_job
      most_current = MidgetJob.order(run_at: :asc).first
      if most_current
        sleep [most_current.run_at.to_f - Time.current.to_f, 0.001].max
      else
        Thread.stop
      end
    end
  end
end
