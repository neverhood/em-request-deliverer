module ILogosEM

  module RequestParser
    extend self

    # Extremely fast and stupid http request parser
    # Not much to look at here

    def parse data
      # split the first line into method, url and protocol ( like GET /send HTTP1/1 )
      parsed = data.split(/\r\n|\n/).first.split(' ')

      # a correct request has three parts
      send_error(400, "Bad request") unless parsed.size == 3

      uri, query_string = parsed[1].split('?')

      # Parse a query string
      if query_string.nil? or query_string.empty?
        params = {}
      else
        params = Hash[
          # Even though we don't expected more then 1 parameter
          query_string.split('&').map do |query|
            query.split('=').tap { |array| array[0] = array.first.to_sym }
            # so that 'url=http://something.com' becomes uri: 'http://something.com'
          end
        ]
      end

      { method: parsed[0], uri: uri, params: params, protocol: parsed[2] }
    end
  end

end
