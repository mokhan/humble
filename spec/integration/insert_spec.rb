require "integration_helper"

describe "orm" do
  include_context "orm"

  context "when inserting a new record" do
    let(:movie) { Movie.new.tap { |x| x.name = 'oop' } }

    before :each do
      session.begin_transaction do |session|
        session.save(movie)
      end
    end

    let(:results) { connection[:movies].all }

    it "should insert the correct number of records" do
      expect(results.count).to eql(1)
    end

    it "should insert the record with the a new id" do
      expect(results.first[:id]).to_not eql(-1)
      expect(results.first[:id]).to be > 0
    end

    it "should insert the name" do
      expect(results.first[:name]).to eql('oop')
    end

    it "should update the new item with the new id" do
      expect(movie.id).to_not eql(-1)
    end
  end
end
