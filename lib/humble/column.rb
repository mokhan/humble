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

    def apply(row, entity, session)
      value = row[column_name]
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

    def apply(row, entity, session)
      value = row[column_name]
      entity.public_send("#{attribute_name}=", session.find(@type, value))
    end

    def prepare(entity)
      { column_name.to_sym => '' }
    end

    private

    def attribute_name
      column_name.to_s.gsub(/_id/, '')
    end
  end

  class HasMany < Column
    def initialize(attribute, type)
      super(attribute)
      @attribute, @type = attribute, type
    end

    def apply(row, entity, session)
      proxy = ArrayProxy.new(session, @type, @attribute, entity)
      entity.public_send("#{@attribute}=", proxy)
    end

    def prepare(entity)
      { }
    end
  end

  class ArrayProxy
    include Enumerable

    def initialize(session, type, attribute, parent_entity)
      @session = session
      @type = type
      @attribute = attribute
      @parent = parent_entity
    end

    def each
      items.each do |item|
        yield item
      end
    end

    def inspect
      "[#{map { |x| x.inspect }.join(", ")}]"
    end

    private

    def items
      @items ||= @session.find_all(@type).find_all do |item|
        item.movie && item.movie.id == @parent.id
      end
    end
  end
end
