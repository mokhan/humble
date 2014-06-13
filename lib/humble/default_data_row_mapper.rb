module Humble
  class DefaultDataRowMapper
    def initialize(configuration)
      @configuration = configuration
    end

    def map_from(row)
      result = @configuration.type.new
      row.each do |key, value|
        result.send("#{key}=", value)
      end
      result
    end
  end
end
