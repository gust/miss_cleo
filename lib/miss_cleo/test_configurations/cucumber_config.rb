module MissCleo
  module TestConfigurations
    class CucumberConfig
      CUCUMBER_MAP = "cucumber_map.json"

      def self.setup_hooks(context)
        map_logger = MissCleo::TestsToFilesMapLogger.new(CUCUMBER_MAP)
        MissCleo::TemplateTracker.initialize_tracker
        ActionView::Template.prepend MissCleo::TestConfigurations::ActionViewConfig if defined? ActionView::Template
        Coverage.start
        context.Around do |scenario, execute|
          MissCleo::TemplateTracker.clear_templates
          before = Coverage.peek_result
          execute.call
          after = Coverage.peek_result
          templates = MissCleo::TemplateTracker.templates.uniq
          if file_and_line = [scenario.location.file, scenario.location.lines.to_s].join(":")
            map_logger.add_to_log(file_and_line, before, after, templates)
          end
        end

        at_exit do
          map_logger.export_logs
        end
      end
    end
  end
end
