require "integration_helper"

describe "updating a record" do
  include_context "orm"

  context "when updating a record" do
    let(:movie) { Movie.new(:name => "old name") }

    before :each do
      session.begin_transaction do |session|
        session.save(movie)
      end
      movie.name="new name"
      session.begin_transaction do |session|
        session.save(movie)
      end
    end

    let(:results) { connection[:movies].all }

    it "should save the changes" do
      results.first[:name].should == 'new name'
    end

    it "should not create any new records" do
      results.count.should == 1
    end
  end
end
