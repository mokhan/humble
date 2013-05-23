module Humble
  class DefaultDataRowMapper
    def initialize(configuration)
      @configuration = configuration
    end

    def map_from(row)
      @configuration[:type].new(row)
    end
  end

  class MappingConfiguration
    def initialize(attributes = {})
      @attributes = {}
      @attributes[:mapper] = DefaultDataRowMapper.new(self)
    end

    def table(name)
      @attributes[:table] = name
    end

    def type(name)
      @attributes[:type] = name
    end

    def primary_key(name)
      @attributes[:primary_key] = name
    end

    def column(name)
      @attributes[:column] = name
    end

    def [](key)
      @attributes[key]
    end
  end

  class DatabaseMapping
    def initialize
      @configuration = MappingConfiguration.new
      run(@configuration)
    end

    def is_for?(item)
      item == configuration[:type] || item.is_a?(configuration[:type])
    end

    def save_using(connection, item)
      connection[configuration[:table]].insert(:name => item.name)
    end

    def find_all_using(connection, clazz)
      Results.new(connection[configuration[:table]], configuration[:mapper])
    end

    private

    attr_reader :configuration

  end
end
