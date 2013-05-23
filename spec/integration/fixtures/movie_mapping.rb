class Movie
  attr_reader :name

  def initialize(attributes)
    @name = attributes[:name]
  end
end

class MovieMapping < Humble::DatabaseMapping
  def run(map)
    map.table :movies
    map.type Movie
    map.primary_key :id
    map.column :name
  end
end

class Results
  include Enumerable

  def initialize(rows, mapper)
    @rows = rows
    @mapper = mapper
  end

  def each(&block)
    @rows.each do |row|
      block.call(@mapper.map_from(row))
    end
  end
end

