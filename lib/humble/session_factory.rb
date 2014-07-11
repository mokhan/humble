module Humble
  class SessionFactory
    def initialize(configuration)
      @configuration = configuration
    end

    def create_session
      Session.new(self, @configuration).tap do |session|
        begin
          yield session if block_given?
        ensure
          session.dispose if block_given?
        end
      end
    end

    def create_connection
      Sequel.connect(@configuration.connection_string)
    end
  end
end
