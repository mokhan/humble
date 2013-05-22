module Humble
  class SessionFactory
    def initialize(configuration)
      @configuration = configuration
    end

    def create_session
      Session.new(self, @configuration)
    end

    def create_connection
      Sequel.connect(@configuration.connection_string)
    end
  end
end
