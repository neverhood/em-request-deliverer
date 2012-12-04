require 'spec_helper'
require 'statistics'

describe ILogosEM::Statistics do

  describe '#to_hash' do
    it 'returns statistics hash' do
      subject.to_hash.should == subject.instance_variable_get('@requests')
    end
  end

  describe '#[]' do
    it 'returns statistics hash for a given key' do
      subject[:received].should == subject.instance_variable_get('@requests')[:received]
    end
  end

  describe 'private #run_routine_for' do
    it 'increments requests count for a current second' do
      sleep 1 if described_class::CURRENT_SECOND.call.zero?

      subject.send :run_routine_for, :received
      subject[:received][described_class::CURRENT_SECOND.call].should == 1
    end
  end

end
