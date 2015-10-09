module MissCleo
  module TestConfigurations
    class RspecConfig
      RSPEC_MAP = "rspec_map.json"
      LOGS = []

      def self.setup_hooks(context)
        if ENV["COVERAGE"]
          Coverage.start
          RSpec.configuration.after(:suite) do
            File.open(RSPEC_MAP, 'w') { |f| f.write JSON.dump LOGS }
          end

          RSpec.configuration.around(:example) do |example|
            before = Coverage.peek_result
            example.call
            after = Coverage.peek_result
            LOGS << [ example.location, CoverageFilter.filter_core(before),
                      CoverageFilter.filter_core(after) ]
          end
        end
      end
    end
  end
end

