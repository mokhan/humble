module Humble
  class DatabaseTable
    attr_reader :name

    def initialize
      @columns = []
    end

    def named(name)
      @name = name
    end

    def primary_key(name, default: 0)
      @primary_key = PrimaryKeyColumn.new(name, default)
    end

    def add_column(name)
      @columns << Column.new(name)
    end

    def persist(connection, item)
      if @primary_key.has_default_value?(item)
        @primary_key.apply(insert(item, connection[@name]) , item)
      else
        update(item, connection[@name])
      end
    end

    def destroy(connection, entity)
      @primary_key.destroy(connection[@name], entity)
    end

    private

    def prepare_statement
      @columns.inject({}) do |result, column|
        result.merge(yield(column))
      end
    end

    def insert(item, connection)
      connection.insert(prepare_statement { |column| column.prepare(item) })
    end

    def update(item, connection)
      connection.update(prepare_statement { |column| column.prepare(item) })
    end
  end
end
