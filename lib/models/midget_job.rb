class MidgetJob < ApplicationRecord
  extend PostgresNotificationsListener

  scope :for_processing, -> { where('run_at < ?', Time.current) }

  validates :job_id, :queue, :serialized, :run_at, presence: true

  def fire_thread
    Rails.logger.info "#{self.class.name} fire_thread started"
    Thread.new do
      Rails.logger.info "#{self.class.name}.fire_thread execute serialized job"
      ActiveJob::Base.execute serialized
    end.abort_on_exception = true
  end

  def self.process_notification(hash_data)
    Midget::Job.process_notification hash_data
  end
end
