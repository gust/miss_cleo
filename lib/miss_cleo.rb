# Pull these into bundler
require 'json'
require 'coverage'
require 'shellwords'
require 'rugged'
require 'set'
require 'gzip'

require "miss_cleo/version"
require 'miss_cleo/coverage_filter'
require 'miss_cleo/coverage_map'
require 'miss_cleo/test_configurations/cucumber_config'
require 'miss_cleo/test_configurations/rspec_config'
require 'miss_cleo/coverage_map_helper.rb'
require 'miss_cleo/test_configurations/rails_action_view_config'
require 'miss_cleo/template_helper'

module MissCleo
end
