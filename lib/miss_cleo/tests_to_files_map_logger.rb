module MissCleo
  class TestsToFilesMapLogger

    def initialize(file_name)
      @logs = []
      @file_name = file_name
    end

    def add_to_log(test_file_and_line, lines_run_before, lines_run_after, templates)
      logs << [ test_file_and_line, {
        before: filter(lines_run_before),
        after: filter(lines_run_after),
        templates: templates
      }]
    end

    def export_logs
      if File.exists?(file_name)
        file = JSON.parse(File.read(file_name))
        @logs += file
      end
      File.open(file_name, 'w') { |f| f.write JSON.dump @logs }
    end

    private

    attr_accessor :logs
    attr_reader :file_name

    def filter(lines_run)
      MissCleo::CoverageFilter.filter_and_trim(lines_run)
    end
  end
end
