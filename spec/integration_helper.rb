require "spec_helper"
require 'sequel'
require_relative 'integration/fixtures/studio_mapping.rb'
require_relative 'integration/fixtures/movie_mapping.rb'
require_relative 'integration/fixtures/review_mapping.rb'

shared_context "orm" do
  let(:connection) { Sequel.connect(connection_string) }
  let(:connection_string) { 'sqlite://test.db' }
  let(:configuration) { Humble::Configuration.new(connection_string) }
  let(:session_factory) { configuration.build_session_factory }
  let(:session) { session_factory.create_session }

  before :each do
    connection.create_table :studios do
      primary_key :id
      String :name
    end

    connection.create_table :movies do
      primary_key :id
      BigNum :studio_id
      String :name
    end

    connection.create_table :reviews do
      primary_key :id
      BigNum :movie_id
      String :description
    end

    configuration.add(MovieMapping.new)
    configuration.add(StudioMapping.new)
    configuration.add(ReviewMapping.new)
  end

  after :each do
    connection.drop_table :studios
    connection.drop_table :movies
    connection.drop_table :reviews
  end
end
