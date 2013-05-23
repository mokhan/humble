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

    def save(item)
      mapping_for(item).save_using(create_connection, item)
    end

    def find_all(clazz)
      mapping_for(clazz).find_all_using(create_connection)
    end

    private

    attr_reader :connection_factory, :mapper_registry

    def create_connection
      @connection ||= connection_factory.create_connection
    end

    def mapping_for(item)
      mapper_registry.mapping_for(item)
    end
  end
end
