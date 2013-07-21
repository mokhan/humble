module Humble
  class Column
    def initialize(attributes)
      @attributes = attributes
    end

    def prepare_insert(item)
      return {} if primary_key?
      key = column_name
      value = item.instance_variable_get("@#{key}")
      { key.to_sym => value }
    end

    def prepare_update(item)
      key = column_name
      value = item.instance_variable_get("@#{key}")
      { key.to_sym => value }
    end

    def primary_key?
      @attributes[:primary_key]
    end

    def column_name
      @attributes[:name]
    end

    def default
      @attributes[:default]
    end

    def apply(id, entity)
      entity.instance_variable_set("@#{column_name}", id ) if primary_key?
    end
  end
end
