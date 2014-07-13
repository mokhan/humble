module Humble
  class MappingConfiguration
    attr_reader :table

    def initialize(table, configuration)
      @table = table
      @configuration = configuration
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

    def primary_key
      @primary_key ||= @table.find do |column|
        column.primary_key?
      end
    end
  end
end
