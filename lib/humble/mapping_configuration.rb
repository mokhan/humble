module Humble
  class MappingConfiguration
    def initialize(table, configuration)
      @table = table
      @configuration = configuration
    end

    def find_all_using(session)
      ResultSet.new(session.create_connection[@table.name], DefaultMapper.new(@table, session))
    end

    def save_using(session, entity)
      connection = session.create_connection[@table.name]
      if primary_key.has_default_value?(entity)
        result = connection.insert(@table.prepare_statement_for(entity))
        primary_key.apply(result, entity, session)
      else
        connection.update(@table.prepare_statement_for(entity))
      end
    end

    def delete_using(session, entity)
      primary_key.destroy(session.create_connection[@table.name], entity)
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
