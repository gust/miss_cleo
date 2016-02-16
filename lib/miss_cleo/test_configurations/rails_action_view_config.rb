module MissCleo
  module TestConfigurations
    module ActionViewConfig
      def render(*args)
        begin
          MissCleo::TestConfigurations::ActionViewHook.record_template(identifier)
        ensure
          super(*args)
        end
      end
    end
  end
end
