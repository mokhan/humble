module Humble
  class ResultSet
    include Enumerable

    def initialize(rows, mapper)
      @rows = rows
      @mapper = mapper
    end

    def each(&block)
      items.each do |item|
        block.call(item)
      end
    end

    def include?(item)
      find do |x|
        x == item
      end
    end

    def inspect
      "[#{map { |x| x.inspect }.join(", ")}]"
    end

    private

    def items
      @items ||= @rows.map do |row|
        @mapper.map_from(row)
      end.to_a
    end
  end
end
