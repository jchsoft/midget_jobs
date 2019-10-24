class CreateMidgetJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :midget_jobs do |t|
      t.string :job_id
      t.string :queue
      t.jsonb :serialized
      t.datetime :run_at

      t.timestamps
    end
    add_index :midget_jobs, :queue
  end
end
