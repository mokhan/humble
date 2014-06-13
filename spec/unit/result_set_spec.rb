require "spec_helper"

describe Humble::ResultSet do
  let(:sut) { Humble::ResultSet.new(rows, mapper) }
  let(:mapper) { double }
  let(:rows) { [{:id => 1}, {id: 2}] }

  before :each do
    mapper.stub(:map_from).with({:id => 1}).and_return(1)
    mapper.stub(:map_from).with({:id => 2}).and_return(2)
  end

  describe :inspect do
    let(:result) { sut.inspect }

    it "should display each row" do
      result.should == "[1, 2]"
    end
  end

  describe :each do
    it "should visit each mapped item" do
      collect = []
      sut.each { |item| collect << item }
      collect.first.should == 1
      collect.last.should == 2
    end
  end

  describe :include? do
    it "should return true" do
      sut.include?(1).should be_truthy
    end

    it "should return false" do
      sut.include?(0).should be_falsey
    end
  end
end
