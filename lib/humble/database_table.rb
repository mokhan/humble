module Humble
  class DatabaseTable
    include Enumerable

    attr_reader :name
    attr_accessor :type

    def initialize
      @columns = []
    end

    def named(name)
      @name = name
    end

    def primary_key(name, default: 0)
      @primary_key = PrimaryKeyColumn.new(name, default)
      add(@primary_key)
    end

    def add(column)
      @columns.push(column)
    end

    def add_column(name)
      add(Column.new(name))
    end

    def each
      @columns.each do |column|
        yield column
      end
    end

    def prepare_statement_for(item)
      @columns.inject({}) do |result, column|
        result.merge(column.prepare(item))
      end
    end
  end
end
