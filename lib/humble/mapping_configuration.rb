module Humble
  class MappingConfiguration
    def initialize(attributes, table)
      @attributes = attributes
      @table = table
    end

    def find_all_using(connection)
      ResultSet.new(connection[@table.name], mapper)
    end

    def save_using(connection, item)
      if  @table.has_default_value?(item)
        id = connection[@table.name].insert(@table.insert(item))
        item.instance_variable_set('@id', id)
      else
        connection[@table.name].update(@table.update(item))
      end
    end

    def is_for?(item)
      item == @attributes[:type] || item.is_a?(@attributes[:type])
    end

    def [](key)
      @attributes[key]
    end

    private

    def mapper
      @attributes[:mapper] || DefaultDataRowMapper.new(self)
    end
  end

end
