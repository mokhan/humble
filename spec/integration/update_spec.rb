require "integration_helper"

describe "updating a record" do
  include_context "orm"

  context "when updating a record" do
    let(:movie) { Movie.new.tap { |x| x.name = "old name" } }

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
      expect(results.first[:name]).to eql('new name')
    end

    it "should not create any new records" do
      expect(results.count).to eql(1)
    end
  end
end
