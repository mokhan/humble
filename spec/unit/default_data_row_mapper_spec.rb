require "ostruct"

class Book
  attr_accessor :id, :name
end

module Humble
  describe DefaultDataRowMapper do
    let(:sut) { Humble::DefaultDataRowMapper.new(configuration) }
    let(:configuration) { OpenStruct.new(:type => Book) }

    let(:result) { sut.map_from({:id => 1, :name => 'blah'}) }

    it "should map the id" do
      expect(result.id).to eql(1)
    end

    it "should map the name" do
      expect(result.name).to eql("blah")
    end
  end
end
