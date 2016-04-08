module MissCleo
  module TestConfigurations
    class RspecConfig
      RSPEC_MAP = "rspec_map.json"
      LOGS = []

      def self.setup_hooks(context)
        if ENV["COVERAGE"]
          MissCleo::TemplateTracker.initialize_tracker
          ActionView::Template.prepend MissCleo::TestConfigurations::ActionViewConfig if defined? ActionView::Template
          Coverage.start
          RSpec.configuration.after(:suite) do
            File.open(RSPEC_MAP, 'w') { |f| f.write JSON.dump LOGS }
          end

          RSpec.configuration.around(:example) do |example|
            MissCleo::TemplateTracker.clear_templates
            before = Coverage.peek_result
            example.call
            after = Coverage.peek_result
            templates = MissCleo::TemplateTracker.templates.uniq
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

