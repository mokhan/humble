module Humble
  class DatabaseMapping
    def initialize(builder = MappingConfigurationBuilder.new)
      run(builder)
      @configuration = builder.build
    end

    def run; end

    def is_for?(item)
      item == configuration[:type] || item.is_a?(configuration[:type])
    end

    def save_using(connection, item)
      configuration.save_using(connection, item)
    end

    def find_all_using(connection)
      configuration.find_all_using(connection)
    end

    private

    attr_reader :configuration

  end
end
