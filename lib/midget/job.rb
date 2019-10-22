require 'models/midget_job'
require 'midget/scheduler'

module Midget
  class Job
    class_attribute :listener

    class << self
      # @param [ActiveJob::Base] job
      # @param [Time] at
      def enqueue(job, at: nil)
        MidgetJob.create!(job_id: job.job_id, queue: job.queue_name, serialized: job.serialize, run_at: (at or 1.second.from_now))
      end

      def enqueued_jobs
        ActiveRecord::Relation.send :alias_method, :clear, :delete_all
        MidgetJob.all
      end

      def schedule
        @listener = Midget::Scheduler.new.call
      end

      def process_notification(hash_data)
        Rails.logger.info "#{self.name}.#{__method__}(#{hash_data})"
        case hash_data[:action]
          when 'INSERT'
            @listener.wakeup!
          else
            raise "unknown action #{hash_data[:action]}"
        end
      end
    end

    def run(serialized_job)
      raise NotImplementedError, "serialized_job: #{serialized_job}"
    end
  end
end
