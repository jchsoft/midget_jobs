require "test_helper"

class MidgetJobTest < Minitest::Test
  def setup
    @attributes = {
      job_id: '98765JHGF765',
      queue: 'hokus',
      serialized: 'something',
      run_at: Time.now
    }
  end

  def test_good_create
    mj = MidgetJob.create @attributes
    refute mj.errors.any?
    assert_equal @attributes[:job_id], mj.job_id
  end

end
