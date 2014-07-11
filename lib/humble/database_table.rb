module Humble
  class DatabaseTable
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

    def persist(connection, item)
      if @primary_key.has_default_value?(item)
        @primary_key.apply(insert(item, connection[@name]) , item, nil)
      else
        update(item, connection[@name])
      end
    end

    def destroy(connection, entity)
      @primary_key.destroy(connection[@name], entity)
    end

    def column_for(key)
      @columns.find { |x| x.matches?(key) }
    end

    private

    def prepare_statement_for(item)
      @columns.inject({}) do |result, column|
        result.merge(column.prepare(item))
      end
    end

    def insert(item, dataset)
      dataset.insert(prepare_statement_for(item))
    end

    def update(item, dataset)
      dataset.update(prepare_statement_for(item))
    end
  end
end
