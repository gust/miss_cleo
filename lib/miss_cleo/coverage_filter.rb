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

    def self.normalize_paths(result_hash)
      normalized_hash = Hash.new
      result_hash.each do |key, value|
        trimmed_key = key.gsub(/#{Regexp.quote(`pwd`.chomp)}\//, "")
        normalized_hash[trimmed_key] = value
      end

      normalized_hash
    end

    def self.filter_and_trim(result_hash)
      filtered = filter_core(result_hash)
      normalize_paths(filtered)
    end

  end

end
