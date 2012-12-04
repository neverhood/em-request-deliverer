require 'spec_helper'
require 'ilogos_em'

require 'open-uri'

describe 'General Behavior' do

  before do
    @em = ILogosEM::EMInstance.new('0.0.0.0', '9005')
    @em_thread = Thread.new { @em.run }

    sleep 0.1 until @em_thread.status == 'sleep'
  end

  it 'Will append a query url to the queue' do
    open 'http://localhost:9005/send?url=http://localhost:9005'
    current_second = ILogosEM::Statistics::CURRENT_SECOND.call

    sleep 1 # We must wait since all of processing happens after response has been received

    @em.statistics[:received][current_second].should    == 1
    @em.statistics[:successfull][current_second].should == 1
  end

end
