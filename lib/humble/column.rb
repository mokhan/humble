module Humble
  class Column
    def initialize(name)
      @column_name = name
    end

    def prepare(item)
      return {} if primary_key? && has_default_value?
      { column_name.to_sym => item.instance_variable_get("@#{column_name}") }
    end

    def primary_key?
      false
    end

    protected

    attr_reader :column_name
  end

  class PrimaryKeyColumn < Column
    attr_reader :default

    def initialize(name, default)
      super(name)
      @default = default
    end

    def apply(id, entity)
      entity.instance_variable_set("@#{column_name}", id )
    end

    def destroy(connection, entity)
      connection.where(column_name.to_sym => entity.id).delete
    end

    def primary_key?
      true
    end

    def has_default_value?(item)
      @default == item.id
    end
  end
end
