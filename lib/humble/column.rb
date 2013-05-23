module Humble
  class Column
    def initialize(attributes)
      @attributes = attributes
    end

    def prepare_insert(item)
      return {} if primary_key?
      key = @attributes[:name]
      value = item.instance_variable_get("@#{key}")
      { key.to_sym => value }
    end

    def primary_key?
      @attributes[:primary_key]
    end
  end
end
