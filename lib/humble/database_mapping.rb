module Humble
  class DatabaseMapping
    attr_reader :configuration

    def initialize(builder = MappingConfigurationBuilder.new)
      run(builder)
      @configuration = builder.build
    end

    def run; end

    def is_for?(item)
      #item == configuration[:type] || item.is_a?(configuration[:type])
      configuration.is_for?(item)
    end

  end
end
