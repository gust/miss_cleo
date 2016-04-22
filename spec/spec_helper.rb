$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'miss_cleo'
require 'pry'


RSpec.configure do |configure|
  if ENV['COVERAGE']
    MissCleo::TestConfigurations::RspecConfig.setup_hooks
  end
end
