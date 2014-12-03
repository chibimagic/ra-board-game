class SunTest < MiniTest::Test
  def test_use
    s = Sun.create_new(1)
    s.use
    e = assert_raises(RuntimeError) { s.use }
    assert_equal("Cannot reuse sun", e.message)
    s.reset
    s.use
  end
end
