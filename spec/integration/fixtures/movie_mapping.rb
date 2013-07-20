class Movie
  attr_reader :id, :name

  def initialize(attributes)
    @id = attributes[:id] || -1
    @name = attributes[:name]
  end

  def name=(new_name)
    @name = new_name
  end
end

class MovieMapping < Humble::DatabaseMapping
  def run(map)
    map.table :movies
    map.type Movie
    map.primary_key(:id, default: -1)
    map.column :name
  end
end
