module MissCleo
  class TestRunner
    def initialize(tests_to_run, lines_changed)
      @tests_to_run = tests_to_run
      @lines_changed = lines_changed
    end

    def run_tests
      # come up with a better way to register tests and test execution
      exec_command = "bundle exec"
      cukes = tests_to_run.select { |test| test.match(/^feature/) }
      specs = tests_to_run.select { |test| test.match(/^\.\/spec/) }
      run_cukes = cukes.empty? ? "" : "#{exec_command} cucumber #{cukes.join(" ")}"
      run_specs = specs.empty? ? "" : "#{exec_command} rspec #{specs.join(" ")}"
      spec_line = specs.empty? ? nil : "(s)pecs"
      cuke_line = cukes.empty? ? nil : "(c)ukes"
      both_line = specs.empty? || cukes.empty? ? nil : "(B)oth cukes and specs"
      puts "Run: " + [spec_line, cuke_line, both_line].compact.join(", ") + " or (n)othing:"
      response = STDIN.gets.chomp
      case response
      when "s"
        puts "Running only specs..."
        exec run_specs
      when "c"
        puts "Running only cukes..."
        exec run_cukes
      when "n"
      else
        puts "Running both specs and cukes..."
        exec [run_cukes, run_specs].join("; ")
      end
    end

    private

    attr_reader :tests_to_run, :lines_changed
  end
end
