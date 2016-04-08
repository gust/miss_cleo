module MissCleo
  module TestSelector
    module_function

    def predict(coverage_map, lines_changed)
      tests_to_run = []
      lines_changed.each do |file, line|
        tests_to_run |= coverage_map.tests_for_lines(file, line)
      end

      tests_to_run.sort.reverse
    end
  end
end
