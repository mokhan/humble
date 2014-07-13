module Humble
  class Session
    def initialize(session_factory, configuration)
      @session_factory = session_factory
      @configuration = configuration
      @identity_map = IdentityMap.new
    end

    def begin_transaction(&block)
      create_connection.transaction do
        block.call(self)
      end
    end

    def save(entity)
      mapping_for(entity).save_using(self, entity)
    end

    def find(clazz, id)
      @identity_map.fetch("#{clazz.name}-#{id}") do
        find_all(clazz).find do |x|
          x.id == id
        end
      end
    end

    def find_all(clazz)
      table = mapping_for(clazz).table
      ResultSet.new(create_connection[table.name], DefaultMapper.new(table, self))
    end

    def delete(entity)
      mapping_for(entity).delete_using(self, entity)
    end

    def dispose
      @connection.disconnect if @connection
      @connection = nil
    end

    def create_connection
      @connection ||= @session_factory.create_connection
    end

    private

    def mapping_for(entity)
      @configuration.mapping_for(entity)
    end
  end
end
