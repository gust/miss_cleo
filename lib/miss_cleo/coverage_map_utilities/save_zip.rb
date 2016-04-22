module MissCleo
  module CoverageMapUtilities
    module SaveZip
      module_function

      def zip(coverage_map)
        File.open("total_coverage_map.json.gz", "w") do |f|
          f.write(JSON.dump(coverage_map.map).gzip)
        end
      end
    end
  end
end
