class Movie
  attr_reader :name

  def initialize(attributes)
    @name = attributes[:name]
  end
end

class MovieMapping
  def is_for?(item)
    item == Movie || item.is_a?(Movie)
  end

  def save_using(connection, item)
    connection[:movies].insert(:name => item.name)
  end

  def find_all_using(connection, clazz)
    Results.new(connection[:movies], MovieMapper.new)
  end

  def run(map)
    map.table :movies
  end
end

class MovieMapper
  def map_from(row)
    Movie.new(row)
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

