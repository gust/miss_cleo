module MissCleo
  module CoverageMapHelper

    def build_deck(filenames)
      cov_map = Hash.new { |h, file| h[file] = Hash.new { |i, line| i[line] = [] } }
      filenames.each do |filename|
        File.open(filename, "r") do |f|
          f.read
        end.tap do |contents|
          begin
            build_coverage_map(cov_map, JSON.parse(contents))
          rescue
            puts "#{filename} is malformed, this may affect test predictons"
          end
        end
      end

      File.open("total_coverage_map.json.gz", "w") do |f|
        f.write(JSON.dump(cov_map).gzip)
      end
    end

    def predict
      repo = Rugged::Repository.new '.'
      lines_changed = Set.new

      repo.index.diff.each_patch do |patch|
        file = patch.delta.old_file[:path]

        patch.each_hunk do |hunk|
          hunk.each_line do |line|
            case line.line_origin
            when :addition
              lines_changed << [file, line.new_lineno] unless exclude_from_map?(file)
            when :deletion
              lines_changed << [file, line.old_lineno] unless exclude_from_map?(file)
            when :context
              # do nothing
            end
          end
        end
      end

      coverage_map = JSON.parse(File.open("total_coverage_map.json.gz").read.gunzip)
      tests_to_run = []
      lines_changed.each do |file, line|
        coverage_map && coverage_map[file] && coverage_map[file].fetch(line.to_s, []).uniq.each do |desc|
          tests_to_run << desc
        end
      end
      if lines_changed.empty?
        puts "No line changes detected."
      elsif tests_to_run.empty?
        puts "No tests found. May be due to blind spot, new tests you've just written, or the changes may be untested."
      else
        puts "Run these tests:"
        puts tests_to_run.uniq.sort
      end
    end


    private

    def exclude_from_map?(file_name)
      # Let's add a configuration for ignored files
      file_name == "db/structure.sql"
    end

    def build_coverage_map(cov_map, cov_diffs)
      cov_diffs.each do |test_to_code_map|
        if test_to_code_map.length == 4 # for Minitest
          test_file_and_line = test_to_code_map.first(2).join('#')
        else                # for RSpec
          test_file_and_line = test_to_code_map.first
        end
        before, after = test_to_code_map.last(2)

        # calculate the per test coverage
        delta = diff before, after

        delta.each_pair do |file, lines|
          file_map = cov_map[file]

          lines.each_with_index do |val, i|
            # skip lines that weren't executed
            next unless val && val > 0

            # add the test name to the map. Multiple tests can execute the same
            # line, so we need to use an array.
            file_map[i + 1] << test_file_and_line
          end
        end
      end
    end

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
