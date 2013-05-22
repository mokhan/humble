require "rubygems"
require 'sequel'
require "sqlite3"

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
    mapping_for(clazz).find_all_using(create_connection, clazz)
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


class Movie
  attr_reader :name

  def initialize(attributes)
    @name = attributes[:name]
  end
end

class DatabaseMapping
end

class MovieMapping < DatabaseMapping
  def is_for?(item)
    item == Movie || item.is_a?(Movie)
  end

  def save_using(connection, item)
    p "SAVING"
    connection[:movies].insert(:name => item.name)
  end

  def find_all_using(connection, clazz)
    connection[:movies]
  end

  def run(map)
    map.table :movies
  end

end


describe "orm" do
  let(:connection) { Sequel.connect(connection_string) }
  let(:connection_string) { 'sqlite://test.db' }

  before :each do
    connection.create_table :movies do
      primary_key :id
      String :name
    end
  end

  after :each do
    connection.drop_table :movies
  end

  it "should work like this" do
    configuration = Configuration.new(connection_string)
    configuration.add(MovieMapping.new)
    session_factory = configuration.build_session_factory
    session = session_factory.create_session
    session.begin_transaction do |session|
      session.save(Movie.new(:name => 'monsters inc'))
    end

    movies = session.find_all Movie
    movies.count.should == 1
  end
end
