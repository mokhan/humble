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

    def include?(item)
      self.find do |x|
        x.id == item.id
      end
    end

    def inspect
      "[#{self.map { |x| x.inspect }.join(", ")}]"
    end
  end
end
