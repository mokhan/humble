class Review
  attr_accessor :id, :description, :movie
end

class ReviewMapping < Humble::DatabaseMapping
  def run(map)
    map.table :reviews
    map.type Review
    map.primary_key(:id, default: -1)
    map.column :description
    map.belongs_to :movie_id, Movie
  end
end
