require 'spec_helper'

describe MissCleo::TestsToFilesMapLogger do
  describe "#add_to_log" do
    it "records the test, before, after, and template" do
      before = double("before")
      after = double("after")
      filtered_before = double("filtered_double")
      filtered_after = double("filtered_after")
      allow(MissCleo::CoverageFilter).to receive(:filter_and_trim).with(before) { filtered_before }
      allow(MissCleo::CoverageFilter).to receive(:filter_and_trim).with(after) { filtered_after }
      test_file_and_line = double("test_file_and_line")

      templates = double("templates")
      logger = described_class.new('test.json')
      logger.add_to_log(test_file_and_line, before, after, templates)
      expect(logger.send(:logs)).to eq([[
        test_file_and_line, {
          before: filtered_before,
          after: filtered_after,
          templates: templates
        }
      ]])
    end
  end

  describe "#export_logs" do
    it "exports logs" do
      file_name = 'test.json'
      logger = described_class.new(file_name)
      logger.export_logs
      expect(File.exists?(file_name)).to be
      FileUtils.rm(file_name)
    end

    it "appends to an existing log" do
      file_name = 'test.json'
      File.open(file_name, 'w') { |f| f.write JSON.dump [["hello"]] }
      logger = described_class.new(file_name)
      logger.export_logs
      lines = File.read(file_name)
      expect(lines).to eq("[[\"hello\"]]")
      FileUtils.rm(file_name)
    end
  end
end
