class CreateMidgetTriggers < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
      CREATE OR REPLACE FUNCTION notice_midget_job_insert() RETURNS trigger AS $$
        DECLARE
          channel_name varchar DEFAULT (TG_TABLE_NAME || '_notices');
        BEGIN
          PERFORM pg_notify(channel_name, json_build_object('action', TG_OP, 'id', NEW.id)::text);

          RETURN NEW;
        END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER notice_on_insert
        AFTER INSERT ON public.midget_jobs FOR EACH ROW
        EXECUTE PROCEDURE notice_midget_job_insert();
    SQL
  end
end
