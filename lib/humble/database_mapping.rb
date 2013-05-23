module Humble
  class DatabaseMapping
    attr_reader :configuration

    def initialize(builder = MappingConfigurationBuilder.new)
      run(builder)
      @configuration = builder.build
    end

    def run; end
  end
end
