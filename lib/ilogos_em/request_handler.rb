module ILogosEM
  class RequestHandler < EM::Connection

    require 'request'
    require 'views'

    def initialize(queue, requests)
      @queue = queue
      @requests = requests

      super
    end

    def receive_data(data)
      request = ILogosEM::Request.new(data)

      # Send
      if request.action == 'send'
        respond_with IlogosEM::Views.ok

        @requests.received!
        @queue << request.params[:url]

      # Stats
      elsif request.action == 'stats'
        respond_with IlogosEM::Views.stats(@requests.to_hash)

      else # Welcome
        respond_with IlogosEM::Views.welcome
      end
    end

    private

    def respond_with opts
      send_data("HTTP/1.1 200 OK\r\n")
      send_data("Content-Type: #{ opts[:content_type] }\r\n")
      send_data("Content-Length: #{ opts[:data].bytesize }\r\n")
      send_data("\r\n")
      send_data("#{ opts[:data] }")

      close_connection_after_writing
    end
  end
end
