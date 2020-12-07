# frozen_string_literal: true

module PostgresNotificationsListener
  TIME_TO_DIE = 3
  EXCEPTION_TIME = 0.333

  def listen_notifications
    Rails.logger.info "#{name} listening_job started"
    Thread.new do
      Rails.logger.info "#{name} listening_job running on #{name.pluralize.underscore}_notices"
      connection.execute "LISTEN #{name.pluralize.underscore}_notices"
      loop do
        Rails.logger.info "#{name} listening_job wait_for_notify"
        connection.raw_connection.wait_for_notify do |event, pid, payload|
          data = JSON.parse payload, symbolize_names: true
          Rails.logger.info "postgres #{event.inspect}, pid: #{pid.inspect}, data: #{data.inspect}"
          process_notification(data)
        end
      rescue PG::ConnectionBad => e
        measure_exception_severity
        Rails.logger.error "#{name} listening_job wait_for_notify lost connection #{e.inspect} retry #{@exception_counter}th time!"
        Rails.logger.error 'Reestablish AR connection...'
        ActiveRecord::Base.connection.verify!
        sleep 0.1
        @exception_counter.to_i < EXCEPTION_TIME ? retry : raise(e)
      rescue StandardError => e
        measure_exception_severity
        Rails.logger.error "#{name} listening_job wait_for_notify exception #{e.inspect} retry #{@exception_counter}th time!"
        sleep 0.1
        @exception_counter.to_i < EXCEPTION_TIME ? retry : raise(e)
      end
    end.abort_on_exception = true
  end

  private

  def measure_exception_severity
    @exception_counter, @last_exception_time = too_soon? ? [exception_counter.to_i + 1, @last_exception_time] : [0, Time.zone.now]
  end

  def too_soon?
    (Time.zone.now - @last_exception_time) < TOO_SOON if @last_exception_time.present?
  end
end
