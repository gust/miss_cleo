module MissCleo
  module TemplateHelper
    module_function

    def template_coverage
      @template_coverage ||= []
    end

    def add_to_template_coverage(template)
      template_coverage << trim_path(template)
    end

    def reset_coverage
      template_coverage = []
    end

    def trim_path(path)
      path.gsub(/#{Regexp.quote(`pwd`.chomp)}\//, "")
    end

  end
end
