require 'spec_helper'
require 'request_parser'

describe ILogosEM::RequestParser do

  describe '#parse' do
    context '1 parameter' do
      it 'returns a query hash' do
        data = 'GET /send?url=http://ya.ru HTTP1/1'

        described_class.parse(data).values.should == ["GET", "/send", {:url=>"http://ya.ru"}, "HTTP1/1"]
      end
    end

    context 'No parameters' do
      it 'returns expected attributes' do
        data = 'GET /stats HTTP1/1'

        described_class.parse(data).values.should == ["GET", "/stats", {}, "HTTP1/1"]
      end
    end
  end

end
