require "spec_helper"

describe Humble::ResultSet do
  let(:sut) { Humble::ResultSet.new(rows, mapper) }
  let(:mapper) { fake }
  let(:rows) { [{:id => 1}, {id: 2}] }

  before :each do
    mapper.stub(:map_from).with({:id => 1}).and_return("1")
    mapper.stub(:map_from).with({:id => 2}).and_return("2")
  end

  describe :inspect do
    let(:result) { sut.inspect }

    it "should display each row" do
      result.should == "[\"1\", \"2\"]"
    end
  end
end
