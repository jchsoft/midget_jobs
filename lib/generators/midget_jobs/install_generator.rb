module MidgetJobs
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)
    desc 'This generator creates an initializer file at config/initializers and migrations to db/migrate'

    def copy_install_file
      copy_file "midget_job_initializer.rb", "config/initializers/midget_jobs.rb"
      copy_file "create_midget_jobs.rb", "db/migrate/#{Time.now.strftime "%Y%m%d%H%M%S"}_create_midget_jobs.rb"
      copy_file "create_midget_triggers.rb", "db/migrate/#{Time.now.strftime "%Y%m%d%H%M%S"}_create_midget_triggers.rb"
    end
  end
end
