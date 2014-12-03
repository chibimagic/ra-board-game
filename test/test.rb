require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative '../app/models/game.rb'

Dir.chdir(File.dirname(__FILE__)) do
  Dir.glob('*_test.rb').each { |file| require_relative file }
end
