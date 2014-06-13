require "integration_helper"

describe "select items" do
  include_context "orm"

  context "when fetching all items" do
    before :each do
      @id = connection[:movies].insert(:name => 'monsters inc')
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
    it "loads the belongs_to association" do
      studio_id = connection[:studios].insert(name: 'universal')
      movie_id = connection[:movies].insert(name: 'blood in, blood out', studio_id: studio_id)

      result = session.find(Movie, movie_id)
      expect(result).to be_instance_of(Movie)
      expect(result.id).to eql(movie_id)
      expect(result.name).to eql('blood in, blood out')
      expect(result.studio).to be_instance_of(Studio)
    end
  end
end
