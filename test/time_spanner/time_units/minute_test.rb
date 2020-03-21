require "test_helper"

module TimeSpanner
  module TimeUnits
    class MinuteTest < TestCase
      it "initializes" do
        minute = Minute.new

        assert minute.is_a?(TimeUnit)
        assert_equal 9, minute.position
        assert_equal :minutes, minute.plural_name
      end

      it "calculates" do
        from = Time.parse("2013-04-03 00:00:00")
        to = Time.parse("2013-04-03 00:02:00")
        duration = to.to_r - from.to_r
        minute = Minute.new

        minute.calculate duration

        assert_equal 2, minute.amount
        assert_equal 0, minute.rest
      end

      it "calculates with rest (999 nanoseconds in seconds)" do
        from = Time.parse("2013-04-03 00:00:00")
        target_minutes = Time.parse("2013-04-03 00:02:00")
        to = Time.at(target_minutes.to_r, 0.999)
        duration = to.to_r - from.to_r
        minute = Minute.new

        minute.calculate duration

        assert_equal 2, minute.amount
        assert_equal Rational(8998192055486251, 9007199254740992000000), minute.rest
      end

      it "should not calculate amount of 2 although units equal" do
        from = Time.parse "2012-06-12 01:12:23"
        time_at_minutes = Time.parse "2012-06-12 01:14:23"
        to = Time.at time_at_minutes.to_r, -0.001
        duration = to.to_r - from.to_r
        minute = Minute.new

        minute.calculate duration, to

        assert_equal 1, minute.amount
        assert minute.rest > 0
      end

      describe "time zone switches" do
        it "switches to summer time" do
          from = DateTime.parse("2013-03-31 01:59:00 CEST").to_time
          to = DateTime.parse("2013-03-31 02:01:00 CEST").to_time
          duration = to.to_r - from.to_r
          minute = Minute.new

          minute.calculate duration

          assert_equal 2, minute.amount
          assert_equal 0, minute.rest
        end

        it "switches to winter time" do
          from = DateTime.parse("2013-10-31 02:59:00 CEST").to_time
          to = DateTime.parse("2013-10-31 03:01:00 CEST").to_time
          duration = to.to_r - from.to_r
          minute = Minute.new

          minute.calculate duration

          assert_equal 2, minute.amount
          assert_equal 0, minute.rest
        end
      end
    end
  end
end
