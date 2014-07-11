module Humble
  class MappingConfiguration
    def initialize(table, configuration)
      @table = table
      @configuration = configuration
    end

    def find_all_using(session, connection = session.create_connection)
      ResultSet.new(connection[@table.name], DefaultMapper.new(@table, session))
    end

    def save_using(connection, entity)
      @table.persist(connection, entity)
    end

    def delete_using(connection, entity)
      @table.destroy(connection, entity)
    end

    def matches?(item)
      @table.type == item || item.is_a?(@table.type)
    end

    private

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
