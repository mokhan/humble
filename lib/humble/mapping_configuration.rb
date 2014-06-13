module Humble
  class MappingConfiguration
    def initialize(table)
      @table = table
    end

    def find_all_using(connection)
      @table.find_all_using(connection)
    end

    def save_using(connection, entity)
      @table.persist(connection, entity)
    end

    def delete_using(connection, entity)
      @table.destroy(connection, entity)
    end

    def matches?(item)
      @table.type == item || item.is_a?(@table.type)
    end
  end
end
