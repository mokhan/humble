class Movie
  attr_accessor :id, :name, :studio

  def ==(other)
    return false unless other
    return false if other.id == -1
    return false if @id == -1
    @id == other.id
  end
end

class MovieMapping < Humble::DatabaseMapping
  def run(map)
    map.table :movies
    map.type Movie
    map.primary_key(:id, default: -1)
    map.column :name
    map.belongs_to :studio_id, Studio
  end
end
