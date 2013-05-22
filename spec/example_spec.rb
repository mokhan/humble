require "rubygems"
require 'sequel'
require "sqlite3"
require_relative '../lib/humble.rb'

class Movie
  attr_reader :name

  def initialize(attributes)
    @name = attributes[:name]
  end
end

class MovieMapping
  def is_for?(item)
    item == Movie || item.is_a?(Movie)
  end

  def save_using(connection, item)
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
    configuration = Humble::Configuration.new(connection_string)
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
