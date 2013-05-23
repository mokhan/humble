module Humble
  class Column
    def initialize(attributes)
      @attributes = attributes
    end

    def prepare_insert(item)
      return {} if primary_key?
      key = @attributes[:name]
      value = item.instance_variable_get("@#{key}")
      { key.to_sym => value }
    end

    def primary_key?
      @attributes[:primary_key]
    end
  end

  class DatabaseTable
    attr_reader :name

    def initialize
      @columns = []
    end

    def named(name)
      @name = name
    end

    def primary_key(name, default: 0)
      @columns << Column.new(:name => name, :default => default, :primary_key => true)
    end

    def add_column(name)
      @columns << Column.new(:name => name)
    end

    def insert(item)
      @columns.inject({}) do |result, column|
        result.merge(column.prepare_insert(item))
      end
    end
  end

  class MappingConfiguration
    def initialize(attributes, table)
      @attributes = attributes
      @table = table
    end

    def find_all_using(connection)
      ResultSet.new(connection[@table.name], mapper)
    end

    def save_using(connection, item)
      connection[@table.name].insert(@table.insert(item))
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

  class MappingConfigurationBuilder
    def initialize(attributes = {}, table = DatabaseTable.new)
      @attributes = attributes
      @table = table
    end

    def table(name)
      @attributes[:table] = name
      @table.named(name)
    end

    def type(name)
      @attributes[:type] = name
    end

    def primary_key(name, default: 0)
      @attributes[:primary_key] = name
      @table.primary_key(name, default: default)
    end

    def column(name)
      @table.add_column(name)
    end

    def build
      MappingConfiguration.new(@attributes, @table)
    end
  end
end
