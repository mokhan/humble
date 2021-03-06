Bundler.require
RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect, :should]
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
    mocks.verify_partial_doubles = true
  end
end
