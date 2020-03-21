module TimeSpanner
  module TimeUnits
    class Millisecond < TimeUnit
      MULTIPLIER = 1000

      def initialize
        super(11, MULTIPLIER)
      end
    end
  end
end
