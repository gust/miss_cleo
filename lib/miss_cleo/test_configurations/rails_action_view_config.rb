module MissCleo
  module TestConfigurations
    module ActionViewConfig
      def render(*args)
        MissCleo::TestConfigurations::ActionViewHook.record_template(identifier)
        super(*args)
      end
    end
  end
end
