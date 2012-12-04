module ILogosEM
  class Request

    require 'request_parser'

    attr_accessor :method, :uri, :params, :protocol, :action

    def initialize(data)
      RequestParser.parse(data).tap do |parsed_data|
        @method   = parsed_data[:method]
        @uri      = parsed_data[:uri]
        @params   = parsed_data[:params]
        @protocol = parsed_data[:protocol]

        @action   = @uri.sub(/^\//, '') # Eliminate a trailing slash
      end
    end

  end
end
