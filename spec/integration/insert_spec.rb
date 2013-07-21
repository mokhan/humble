require "integration_helper"

describe "orm" do
  include_context "orm"

  context "when inserting a new record" do
    let(:movie) { Movie.new(:name => 'oop') }

    before :each do
      session.begin_transaction do |session|
        session.save(movie)
      end
    end

    let(:results) { connection[:movies].all }

    it "should insert the correct number of records" do
      results.count.should == 1
    end

    it "should insert the record with the a new id" do
      results.first[:id].should_not == -1
      results.first[:id].should > 0
    end

    it "should insert the name" do
      results.first[:name].should == 'oop'
    end

    it "should update the new item with the new id" do
      movie.id.should_not == -1
    end
  end
end
