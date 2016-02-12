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
            MissCleo::TemplateHelper.reset_coverage
            before = Coverage.peek_result
            example.call
            after = Coverage.peek_result
            templates = MissCleo::TemplateHelper.template_coverage
            LOGS << [ example.location, {
              before: CoverageFilter.filter_and_trim(before),
              after: CoverageFilter.filter_and_trim(after),
              templates: templates
            } ]
          end
        end
      end
    end
  end
end

