module Humble
  class DefaultDataRowMapper
    def initialize(configuration)
      @configuration = configuration
    end

    def map_from(row)
      @configuration[:type].new(row)
    end
  end
end
