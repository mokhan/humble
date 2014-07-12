module Humble
  class MappingConfiguration
    def initialize(table, configuration)
      @table = table
      @configuration = configuration
    end

    def find_all_using(session)
      ResultSet.new(session.create_connection[@table.name], mapper_for(session))
    end

    def save_using(session, entity)
      connection = session.create_connection[@table.name]
      if primary_key.has_default_value?(entity)
        connection.insert(@table.prepare_statement_for(entity))
        primary_key.apply(connection, entity, session)
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

    def mapper_for(session)
      DefaultMapper.new(@table, session)
    end

    def primary_key
      @primary_key ||= @table.find do |column|
        column.primary_key?
      end
    end

    class DefaultMapper
      attr_reader :session, :table

      def initialize(table, session)
        @table = table
        @session = session
      end

      def map_from(row)
        entity = table.type.new
        table.each do |column|
          column.apply(row, entity, session)
        end
        entity
      end
    end
  end
end
