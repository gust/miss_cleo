module MissCleo
  module TestConfigurations
    class CucumberConfig
      CUCUMBER_MAP = "cucumber_map.json"
      LOGS = []

      def self.setup_hooks(context)
        if ENV["COVERAGE"]
          Coverage.start
          context.Around do |scenario, execute|
            before = Coverage.peek_result
            execute.call
            after = Coverage.peek_result
            if file_and_line = scenario.try(:file_colon_line)
              LOGS << [ file_and_line, before, after ]
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
