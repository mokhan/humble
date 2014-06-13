module Humble
  class Column
    attr_reader :column_name

    def initialize(name)
      @column_name = name
    end

    def prepare(entity)
      return {} if primary_key? && has_default_value?(entity)
      { column_name.to_sym => entity.public_send(column_name.to_sym) }
    end

    def matches?(column_name)
      @column_name == column_name
    end

    def apply(value, entity)
      entity.public_send("#{@column_name}=", value)
    end

    def primary_key?
      false
    end
  end

  class PrimaryKeyColumn < Column
    attr_reader :default

    def initialize(name, default)
      super(name)
      @default = default
    end

    def destroy(connection, entity)
      connection.where(column_name.to_sym => entity.id).delete
    end

    def primary_key?
      true
    end

    def has_default_value?(entity)
      entity.id == nil || @default == entity.id
    end
  end

  class BelongsTo < Column
    def initialize(name, type)
      super(name)
      @type = type
    end

    def apply(value, entity)
      child_entity = @type.new
      column = column_name.to_s.gsub(/_id/, '')
      entity.public_send("#{column}=", child_entity)
    end

    def prepare(entity)
      { column_name.to_sym => '' }
    end
  end
end
