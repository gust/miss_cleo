module MissCleo
  module TemplateTracker
    module_function

    def initialize_tracker
      @templates = []
    end

    def add_to_template_coverage(template)
      @templates << (trim_path(template))
    end

    def clear_templates
      @templates.clear
    end

    def templates
      @templates
    end

    def trim_path(path)
      path.gsub(/#{Regexp.quote(`pwd`.chomp)}\//, "")
    end

    private_class_method :trim_path
  end
end
