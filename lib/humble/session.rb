module Humble
  class Session
    def initialize(connection_factory, mapper_registry)
      @connection_factory = connection_factory
      @mapper_registry = mapper_registry
    end

    def begin_transaction(&block)
      create_connection.transaction do
        block.call(self)
      end
    end

    def save(entity)
      mapping_for(entity).save_using(create_connection, entity)
    end

    def find(clazz, id)
      find_all(clazz).find { |x| x.id == id }
    end

    def find_all(clazz)
      mapping_for(clazz).find_all_using(create_connection)
    end

    def delete(entity)
      mapping_for(entity).delete_using(create_connection, entity)
    end

    def dispose
      @connection.disconnect if @connection
      @connection = nil
    end

    private

    attr_reader :connection_factory, :mapper_registry

    def create_connection
      @connection ||= connection_factory.create_connection
    end

    def mapping_for(entity)
      mapper_registry.mapping_for(entity)
    end
  end
end
