require "spec_helper"
class Book
  attr_reader :id, :name

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
  end
end

describe Humble::DefaultDataRowMapper do
  let(:sut) { Humble::DefaultDataRowMapper.new(configuration) }
  let(:configuration) { { :type => Book } }

  let(:result) { sut.map_from({:id => 1, :name => 'blah'}) }

  it "should map the id" do
    result.id.should == 1
  end

  it "should map the name" do
    result.name.should == "blah"
  end
end
