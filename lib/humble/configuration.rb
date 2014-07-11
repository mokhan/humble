module Humble
  class Configuration
    attr_reader :connection_string

    def initialize(connection_string, table_builder = MappingConfigurationBuilder.new)
      @mapping_configurations = []
      @connection_string = connection_string
      @table_builder = table_builder
    end

    def add(mapping)
      @mapping_configurations.push(MappingConfiguration.new(@table_builder.build(mapping), self))
    end

    def build_session_factory
      SessionFactory.new(self)
    end

    def mapping_for(item)
      @mapping_configurations.find do |mapping|
        mapping.matches?(item)
      end
    end
  end
end
