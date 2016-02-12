module MissCleo
  module TestConfigurations
    module ActionViewHook
      module_function

      def record_template(template)
        MissCleo::TemplateHelper.add_to_template_coverage(template)
      end
    end
  end
end
