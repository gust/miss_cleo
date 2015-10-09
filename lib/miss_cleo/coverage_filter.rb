module MissCleo
  class CoverageFilter
    GEM_PATHS = ENV["GEM_PATH"].split(":")
    RUBY_PATH = `which ruby`.chomp.gsub("/bin/ruby","")

    def self.filter_core(result_hash)

      # Don't include gems in coverage map
      result_hash.reject do |file, line|
        ([RUBY_PATH] + GEM_PATHS).any? { |path| file.include?(path) }
      end
    end
  end

end
