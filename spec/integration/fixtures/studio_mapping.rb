class Studio
  attr_accessor :id, :name
end

class StudioMapping < Humble::DatabaseMapping
  def run(map)
    map.table :studios
    map.type Studio
    map.primary_key(:id, default: -1)
    map.column :name
  end
end
