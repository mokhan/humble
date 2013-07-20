require "spec_helper"
require_relative 'integration/fixtures/movie_mapping.rb'

shared_context "orm" do
  let(:connection) { Sequel.connect(connection_string) }
  let(:connection_string) { 'sqlite://test.db' }
  let(:configuration) { Humble::Configuration.new(connection_string) }
  let(:session_factory) { configuration.build_session_factory }
  let(:session) { session_factory.create_session }

  before :each do
    connection.create_table :movies do
      primary_key :id
      String :name
    end

    configuration.add(MovieMapping.new)
  end

  after :each do
    connection.drop_table :movies
  end

end
