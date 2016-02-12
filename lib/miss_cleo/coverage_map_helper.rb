module MissCleo
  module CoverageMapHelper

    def build_deck(file_names)
      cov_map = ::MissCleo::CoverageMap.new
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

      File.open("total_coverage_map.json.gz", "w") do |f|
        f.write(JSON.dump(cov_map.map).gzip)
      end
    end

    def predict(unzipped_file)
      coverage_map = ::MissCleo::CoverageMap.new(JSON.parse(unzipped_file))
      tests_to_run = []
      lines_changed.each do |file, line|
        tests_to_run |= coverage_map.tests_for_lines(file, line)
      end
      if lines_changed.empty?
        puts "No line changes detected."
      elsif tests_to_run.empty?
        puts "No tests found. May be due to blind spot, new tests you've just written, or the changes may be untested."
      else
        puts "Run these tests:"
        puts tests_to_run.sort.reverse
      end

      tests_to_run
    end


    private

    def exclude_from_map?(file_name)
      # Let's add a configuration for ignored files
      file_name == "db/structure.sql"
    end


    def lines_changed
      @_lines_changed ||= Set.new.tap do |changed_lines|
        repo = Rugged::Repository.new '.'
        repo.index.diff.each_patch do |patch|
          file = patch.delta.old_file[:path]

          patch.each_hunk do |hunk|
            hunk.each_line do |line|
              case line.line_origin
              when :addition
                changed_lines << [file, line.new_lineno] unless exclude_from_map?(file)
              when :deletion
                changed_lines << [file, line.old_lineno] unless exclude_from_map?(file)
              when :context
                # do nothing
              end
            end
          end
        end

      end
    end
  end
end
