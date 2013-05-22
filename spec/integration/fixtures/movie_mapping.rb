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
    connection[:movies]
  end

  def run(map)
    map.table :movies
  end
end

