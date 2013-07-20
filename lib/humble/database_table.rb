module Humble
  class DatabaseTable
    attr_reader :name

    def initialize
      @columns = []
    end

    # configuration methods
    def named(name)
      @name = name
    end

    def primary_key(name, default: 0)
      @columns << Column.new(:name => name, :default => default, :primary_key => true)
    end

    def add_column(name)
      @columns << Column.new(:name => name)
    end

    def insert(item)
      @columns.inject({}) do |result, column|
        result.merge(column.prepare_insert(item))
      end
    end

    def update(item)
      @columns.inject({}) do |result, column|
        result.merge(column.prepare_update(item))
      end
    end

    # query methods

    def has_default_value?(item)
      primary_key_column.default == item.id
    end

    private

    def primary_key_column
      @columns.find { |x| x.primary_key? }
    end
  end
end
