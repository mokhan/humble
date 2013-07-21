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
      @columns << Column.new(:name => name, :default => default, :primary_key => true)
    end

    def add_column(name)
      @columns << Column.new(:name => name)
    end

    def persist(connection, item)
      if has_default_value?(item)
        insert(item, connection[@name])
      else
        update(item, connection[@name])
      end
    end

    def destroy(connection, entity)
      connection[@name].where(:id => entity.id).delete
    end

    private

    def has_default_value?(item)
      primary_key_column.default == item.id
    end

    def primary_key_column
      @columns.find { |x| x.primary_key? }
    end

    def prepare_statement
      @columns.inject({}) do |result, column|
        result.merge(yield(column))
      end
    end

    def insert(item, connection)
      id = connection.insert(prepare_statement { |column| column.prepare_insert(item) })
      primary_key_column.apply(id, item)
    end

    def update(item, connection)
      connection.update( prepare_statement { |column| column.prepare_update(item) })
    end
  end
end
