module MissCleo
  class CoverageMap

    attr_reader :map

    def initialize(map = nil)
      @map = map || Hash.new { |h, file| h[file] = Hash.new { |i, line| i[line] = [] } }
    end

    def add_to_coverage_map(test_diffs)
      test_diffs.each do |test_to_code_map|
        test_file_and_line = test_to_code_map.first
        before, after = test_to_code_map.last(2)

        # calculate the per test coverage
        delta = diff before, after

        delta.each_pair do |file, lines|
          file_map = map[file]

          lines.each_with_index do |val, i|
            # skip lines that weren't executed
            next unless val && val > 0

            # add the test name to the map. Multiple tests can execute the same
            # line, so we need to use an array.
            file_map[i + 1] << test_file_and_line
          end
        end
      end

      nil
    end

    def tests_for_lines(file, line)
      begin
        map[file][line].uniq || []
      rescue
        []
      end
    end

    private

    def diff before, after
      after.each_with_object({}) do |(file_name,line_cov), res|
        before_line_cov = before[file_name] || []

        # skip arrays that are exactly the same
        next if before_line_cov == line_cov

        # subtract the old coverage from the new coverage
        cov = line_cov.zip(before_line_cov).map do |line_after, line_before|
          if line_before
            line_after - line_before
          else
            line_after
          end
        end

        # add the "diffed" coverage to the hash
        res[file_name] = cov
      end
    end
  end
end
