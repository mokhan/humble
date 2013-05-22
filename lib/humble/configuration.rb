module Humble
  class Configuration
    attr_reader :connection_string

    def initialize(connection_string)
      @mappings = []
      @connection_string = connection_string
    end

    def add(mapping)
      @mappings.push(mapping)
    end

    def build_session_factory
      SessionFactory.new(self)
    end

    def mapping_for(item)
      @mappings.find do |mapping|
        mapping.is_for?(item)
      end
    end
  end
end
