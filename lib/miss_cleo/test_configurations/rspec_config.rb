module MissCleo
  module TestConfigurations
    class RspecConfig
      RSPEC_MAP = "rspec_map.json"

      def self.setup_hooks
        logger = MissCleo::TestsToFilesMapLogger.new(RSPEC_MAP)
        MissCleo::TemplateTracker.initialize_tracker
        ActionView::Template.prepend MissCleo::TestConfigurations::ActionViewConfig if defined? ActionView::Template
        Coverage.start
        RSpec.configuration.after(:suite) do
          logger.export_logs
        end

        RSpec.configuration.around(:example) do |example|
          MissCleo::TemplateTracker.clear_templates
          before = Coverage.peek_result
          example.call
          after = Coverage.peek_result
          templates = MissCleo::TemplateTracker.templates.uniq
          logger.add_to_log(example.location, before, after, templates)
        end
      end
    end
  end
end

