module MissCleo
  module TestConfigurations
    module ActionViewConfig
      def render(*args)
        MissCleo::TemplateTracker.add_to_template_coverage(identifier)
        super(*args)
      end
    end
  end
end
