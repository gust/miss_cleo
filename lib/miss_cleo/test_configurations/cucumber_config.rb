module MissCleo
  module TestConfigurations
    class CucumberConfig
      CUCUMBER_MAP = "cucumber_map.json"
      LOGS = []

      def self.setup_hooks(context)
        if ENV["COVERAGE"]
          MissCleo::TemplateTracker.initialize_tracker
          ActionView::Template.prepend MissCleo::TestConfigurations::ActionViewConfig if defined? ActionView::Template
          Coverage.start
          context.Around do |scenario, execute|
            MissCleo::TemplateTracker.clear_templates
            before = Coverage.peek_result
            execute.call
            after = Coverage.peek_result
            templates = MissCleo::TemplateTracker.templates.uniq
            if file_and_line = scenario.try(:file_colon_line)
              LOGS << [ file_and_line, { before: CoverageFilter.filter_and_trim(before), after: CoverageFilter.filter_and_trim(after), templates: templates } ]
            end
          end

          at_exit do
            File.open(CUCUMBER_MAP, 'w') { |f| f.write JSON.dump LOGS }
          end
        end
      end
    end
  end
end
