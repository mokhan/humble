module Humble
  class MappingConfiguration
    def initialize(attributes, table)
      @attributes = attributes
      @table = table
    end

    def find_all_using(connection)
      ResultSet.new(connection[@table.name], mapper)
    end

    def save_using(connection, entity)
      @table.persist(connection, entity)
    end

    def delete_using(connection, entity)
      @table.destroy(connection, entity)
    end

    def matches?(item)
      self[:type] == item || item.is_a?(self[:type])
    end

    def [](key)
      @attributes[key]
    end

    private

    def mapper
      self[:mapper] || DefaultDataRowMapper.new(self)
    end
  end
end
