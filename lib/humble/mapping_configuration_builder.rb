module Humble
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
