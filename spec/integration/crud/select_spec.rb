require "integration_helper"

describe "select items" do
  include_context "orm"

  context "when fetching all items" do
    before :each do
      @id = connection[:movies].insert(:name => 'monsters inc')
    end

    let(:results) { session.find_all Movie }

    it "should return the correct number of movies" do
      results.count.should == 1
    end

    it "should return each movie with its name" do
      results.first.name.should == 'monsters inc'
    end

    it "should return instances of the target type" do
      results.first.should be_instance_of(Movie)
    end

    it "should include the saved movie" do
      results.should include(Movie.new(:id => @id, :name => 'monsters inc'))
    end
  end

end
