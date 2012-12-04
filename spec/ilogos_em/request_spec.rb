require 'spec_helper'
require 'request'

describe ILogosEM::Request do

  let(:request) { described_class.new('GET /send?url=http://ya.ru HTTP1/1') }

  describe '#initialize' do
    it 'assigns expected attributes' do
      request.method.should == 'GET'
      request.action.should == 'send'
      request.params.should == { url: 'http://ya.ru' }
      request.protocol.should == 'HTTP1/1'
      request.uri.should == '/send'
    end
  end

end
