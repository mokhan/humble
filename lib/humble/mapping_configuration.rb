module Humble
  class MappingConfiguration
    def initialize(table, configuration)
      @table = table
      @configuration = configuration
    end

    def find_all_using(session, connection = session.create_connection)
      ResultSet.new(connection[@table.name], DefaultMapper.new(@table, session))
    end

    def save_using(session, entity)
      if primary_key.has_default_value?(entity)
        primary_key.apply(insert(entity, session.create_connection[@table.name]) , entity, nil)
      else
        update(entity, session.create_connection[@table.name])
      end
    end

    def delete_using(connection, entity)
      @table.destroy(connection, entity)
    end

    def matches?(item)
      @table.type == item || item.is_a?(@table.type)
    end

    private

    def primary_key
      @primary_key ||= @table.find do |column|
        column.primary_key?
      end
    end

    def insert(item, dataset)
      dataset.insert(@table.prepare_statement_for(item))
    end

    def update(item, dataset)
      dataset.update(@table.prepare_statement_for(item))
    end

    class DefaultMapper
      def initialize(table, session)
        @table = table
        @session = session
      end

      def map_from(row)
        @table.type.new.tap do |entity|
          row.each do |key, value|
            @table.column_for(key).apply(value, entity, @session)
          end
        end
      end
    end
  end
end
