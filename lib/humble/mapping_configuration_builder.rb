module Humble
  class MappingConfigurationBuilder
    def table(name)
      @table.named(name)
    end

    def type(name)
      @table.type=name
    end

    def primary_key(name, default: 0)
      @table.primary_key(name, default: default)
    end

    def column(name)
      @table.add_column(name)
    end

    def belongs_to(foreign_key, type)
      @table.add(BelongsTo.new(foreign_key, type))
    end

    def has_many(attribute_name, type)
      @table.add(HasMany.new(attribute_name, type))
    end

    def build(mapping)
      @table = DatabaseTable.new
      mapping.run(self)
      @table
    end
  end
end
