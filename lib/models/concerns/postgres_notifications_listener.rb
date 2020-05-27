# frozen_string_literal: true

module PostgresNotificationsListener
  def listen_notifications
    Rails.logger.info "#{name} listening_job started"
    Thread.new do
      Rails.logger.info "#{name} listening_job running on #{name.pluralize.underscore}_notices"
      connection.execute "LISTEN #{name.pluralize.underscore}_notices"
      exception_counter ||= 0
      loop do
        Rails.logger.info "#{name} listening_job wait_for_notify"
        connection.raw_connection.wait_for_notify do |event, pid, payload|
          data = JSON.parse payload, symbolize_names: true
          Rails.logger.info "postgres #{event.inspect}, pid: #{pid.inspect}, data: #{data.inspect}"
          process_notification(data)
        end
        exception_counter = 0
      rescue PG::ConnectionBad => e
        exception_counter += 1
        Rails.logger.error "#{name} listening_job wait_for_notify lost connection #{e.inspect} retry #{exception_counter}th time!"
        Rails.logger.error "Reestablish AR connection..."
        ActiveRecord::Base.connection.verify!
        sleep 0.1
        (exception_counter < 3) ? retry : raise(e)
      rescue StandardError => e
        exception_counter += 1
        Rails.logger.error "#{name} listening_job wait_for_notify exception #{e.inspect} retry #{exception_counter}th time!"
        sleep 0.1
        (exception_counter < 3) ? retry : raise(e)
      end
    end.abort_on_exception = true
  end
end
