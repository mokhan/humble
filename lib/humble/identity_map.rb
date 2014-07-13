module Humble
  class IdentityMap
    def initialize(items = {})
      @items = items
    end

    def fetch(key, &block)
      if @items.key?(key)
        @items[key]
      else
        @items[key] = block.call
        @items[key]
      end
    end
  end
end
