module Humble
  class ResultSet
    include Enumerable

    def initialize(rows, mapper)
      @rows = rows
      @mapper = mapper
    end

    def each(&block)
      @rows.each do |row|
        block.call(@mapper.map_from(row))
      end
    end
  end
end
