module MissCleo
  class CoverageMap

    def self.build(file_names)
      cov_map = self.new
      file_names.each do |file_name|
        File.open(file_name, "r") do |f|
          f.read
        end.tap do |contents|
          begin
            cov_map.add_to_coverage_map(JSON.parse(contents))
          rescue
            puts "#{file_name} is malformed, this may affect test predictons"
          end
        end
      end

      cov_map
    end

    attr_reader :map

    def initialize(map = nil)
      @map = map || Hash.new { |h, file| h[file] = Hash.new { |i, line| i[line] = [] } }
    end

    def add_to_coverage_map(test_diffs)
      test_diffs.each do |test_to_code_map|
        test_file_and_line = test_to_code_map.first
        before = test_to_code_map.last["before"]
        after = test_to_code_map.last["after"]
        templates = test_to_code_map.last["templates"]

        # calculate the per test coverage
        delta = diff before, after
        add_delta_to_map(delta, test_file_and_line)
        add_templates_to_map(templates, test_file_and_line)
      end

      nil
    end

    def tests_for_lines(file, line)
      begin
        # NOTE: This is currently how templates and non-templates are being
        # split. Since I will likely have to cover a bunch of blind spots
        # manually like this, this probably needs to be rearchitected.
        if file.include?("app/views")
          map[file]["0"].uniq || []
        else
          map[file][line.to_s].uniq || []
        end
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

    def add_delta_to_map(delta, test_file_and_line)
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

    def add_templates_to_map(templates, test_file_and_line)
      templates.each do |template|
        # NOTE: Currently templates do not know how many lines of code they
        # are. I have temporarily decided to shove them into the 0 line
        # to make them a special case. This will probably require
        # re-architecting
        map[template][0] << test_file_and_line
      end

    end
  end
end
