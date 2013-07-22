# Humble

I really miss working with NHibernate. The ruby world has many very
popular orms such as ActiveRecord, DataMapper and DataMappify.

This is my attempt at building a light weight ORM with heavy influences from NHibernate. 
It is a work in progress and not ready for production.

## Installation

Add this line to your application's Gemfile:

    gem 'humble'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install humble

## Usage

Let's say you have a class called Movie.

```ruby

  class Movie
    attr_reader :id, :name

    def initialize(attributes)
      @id = attributes[:id] || -1
      @name = attributes[:name]
    end
  end

```

This is how you would define the mapping to the database.

```ruby

  class MovieMapping < Humble::DatabaseMapping
    def run(map)
      map.table :movies
      map.type Movie
      map.primary_key(:id, default: -1)
      map.column :name
    end
  end

```

To connect to the database you need a session.

```ruby

  configuration = Humble::Configuration.new('sqlite://movies.db')
  configuration.add(MovieMapping.new)
  session_factory = configuration.build_session_factory

  session = session_factory.create_session
  session.begin_transaction do |session|
    session.save(Movie.new(:name => 'Man on Fire'))
  end

  all_movies = session.find_all(Movie)
  all_movies.each do |movie|
    session.delete(movie)
  end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
