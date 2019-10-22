module Midget
  class Scheduler
    def call
      Rails.logger.info "#{self.class.name} call started"
      @thread = Thread.new do
        sleep 3 # safe delay - give Rails some time
        Rails.logger.info "#{self.class.name}.call thread"
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
        MidgetJob.for_processing.lock("FOR UPDATE SKIP LOCKED").each do |midget_job|
          Rails.logger.info "firing midget_job: #{midget_job.id}"
          midget_job.fire_thread
          midget_job.destroy!
        end
      end
    end

    # interval till next job or 0 if there is no job - meaning sleep for ever or till wakeup
    def sleep_till_next_job
      most_current = MidgetJob.order(run_at: :asc).first
      if most_current
        sleep [most_current.run_at.to_i - Time.current.to_i, 0.001].max
      else
        Thread.stop
      end
    end
  end
end
