require 'rspec'
require 'rspec/its'

Dir.glob(File.expand_path('../support/shellout_types/*.rb', __FILE__)).each { |f| require(f) }
