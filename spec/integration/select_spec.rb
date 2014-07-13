require "integration_helper"

describe "select items" do
  include_context "orm"

  context "when fetching all items" do
    before :each do
      @id = connection[:movies].insert(name: 'monsters inc')
    end

    let(:results) { session.find_all Movie }

    it "should return the correct number of movies" do
      expect(results.count).to eql(1)
    end

    it "should return each movie with its name" do
      expect(results.first.name).to eql('monsters inc')
    end

    it "should return instances of the target type" do
      expect(results.first).to be_instance_of(Movie)
    end

    it "should include the saved movie" do
      movie = Movie.new.tap { |x| x.id = @id }
      expect(results).to include(movie)
    end
  end

  context "when fetching a single item" do
    let!(:studio_id) { connection[:studios].insert(name: 'universal') }
    let!(:movie_id) { connection[:movies].insert(name: 'blood in, blood out', studio_id: studio_id) }
    let!(:review_id) { connection[:reviews].insert(movie_id: movie_id, description: description) }
    let!(:other_review_id) { connection[:reviews].insert(movie_id: movie_id + 1, description: 'blah blah') }
    let(:result) { session.find(Movie, movie_id) }
    let(:description) { 'wow... that snail is fast.' }

    it "loads the proper type" do
      expect(result).to be_instance_of(Movie)
    end

    it "loads the primary key" do
      expect(result.id).to eql(movie_id)
    end

    it "loads each mapped column" do
      expect(result.name).to eql('blood in, blood out')
    end

    it "loads the belongs_to association" do
      expect(result.studio).to be_instance_of(Studio)
      expect(result.studio.name).to eql('universal')
    end

    it "loads a has_many association" do
      expect(result.reviews).to_not be_nil
      expect(result.reviews.first.description).to eql(description)
      expect(result.reviews.first.description).to eql(description)
    end

    it "does not load items associated with another parent record" do
      expect(result.reviews.find { |x| x.id == other_review_id }).to be_nil
    end
  end
end
