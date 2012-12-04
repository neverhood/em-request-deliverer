module ILogosEM
  class Statistics

    CURRENT_SECOND = -> { Time.now.sec }

    def initialize
      @requests = { received: default_value, successfull: default_value, failed: default_value }
    end

    def [] key
      @requests[key] unless @requests[key].nil?
    end

    def to_hash
      @requests
    end

    def success!
      run_routine_for :successfull
    end

    def fail!
      run_routine_for :failed
    end

    def received!
      run_routine_for :received
    end

    def clear!
      @requests = { received: default_value, successfull: default_value, failed: default_value }
    end

    private

    def run_routine_for stats
      current_second = CURRENT_SECOND.call

      @requests[stats][current_second] += 1 unless current_second.zero? # We start from "1"
    end

    def default_value
      Hash[ (1..59).map { |num| [num, 0] } ]
    end

  end
end
