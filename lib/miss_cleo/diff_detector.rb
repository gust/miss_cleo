module MissCleo
  module DiffDetector
    module_function
    def lines_changed
      Set.new.tap do |changed_lines|
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


    def exclude_from_map?(file_name)
      # Let's add a configuration for ignored files
      file_name == "db/structure.sql"
    end

    private_class_method :exclude_from_map?
  end
end
