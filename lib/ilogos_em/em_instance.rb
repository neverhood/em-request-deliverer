require 'request_handler'
require 'statistics'

module ILogosEM
  class EMInstance
    attr_reader :queue, :statistics

    def initialize(host = '0.0.0.0', port = '9000')
      @queue = EM::Queue.new
      @statistics = ILogosEM::Statistics.new

      @host = host
      @port = port
    end

    def run
      EM.run do
        @webserver = EM.start_server(@host, @port, ILogosEM::RequestHandler, queue, statistics)

        puts "Server started on #{@host}:#{@port}"

        process_queue = proc do |url|
          EM.defer do
            request = EM::HttpRequest.new(url).get

            request.callback do |http|
              if http.response_header.status < 400 # Treat as successfull
                statistics.success!
              else # Treat as failed
                statistics.fail!
              end
            end

            queue.pop(&process_queue)
          end
        end
        queue.pop(&process_queue)

        # Since we're collecting statistics per minute, we'll need to empty all of the data each minute
        # We want a (n)..59 seconds chart, that's why we do not set 60 seconds timer
        EM.add_periodic_timer(1) do
          statistics.clear! if ILogosEM::Statistics::CURRENT_SECOND.call == 0
        end
      end
    end

    def stop
      EM.stop_server @webserver # No new requests accepted

      if queue.empty?
        EM.stop
      else
        puts "Waiting for #{queue.size} requests to finish"
        EM.add_periodic_timer(1) { EM.stop if queue.empty? }
      end
    end

    def stop! # !!1
      EM.stop_server @webserver
      EM.stop
    end

  end
end
