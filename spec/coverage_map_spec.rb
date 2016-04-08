require 'spec_helper'

describe MissCleo::CoverageMap do
  describe "#initialize" do
    it "initializes with a properly nested Hash" do
      expect(subject.map["what"]["test"]).to be_a(Array)
    end
  end

  describe "#add_to_coverage_map" do
    let(:line_coverage_before) { [0, 0] }
    let(:line_coverage_after) { [1, 1] }
    let(:test_diffs) do
      [
        [
          "test",
          { "before" =>
            {"tested_file" => line_coverage_before },
            "after" =>
            { "tested_file" => line_coverage_after },
              "templates" => []
          }
        ]
      ]
    end

    it "adds new coverage data to the map" do
      subject.add_to_coverage_map(test_diffs)
      expect(subject.map["tested_file"][1]).to eq(["test"])
      expect(subject.map["tested_file"][2]).to eq(["test"])
    end
  end

  describe "#tests_for_lines" do
    context "when the coverage map contains the file and line" do
      let(:coverage_map) do
        {
          "file_1" => {
            "1" => ["test"],
            "2" => ["test"],
          }
        }
      end
      it "returns array containing all tests containing file and line" do
        tests_to_run = described_class.new(coverage_map).tests_for_lines("file_1", "1")
        expect(tests_to_run).to eq(["test"])
      end

    end
    context "when the coverage map does not contain the file and line" do
      let(:coverage_map) do
        {
          "file_1" => {
            "2" => ["test"]
          }
        }
      end
      it "returns an empty array" do
        expect(described_class.
               new(coverage_map).
               tests_for_lines("file_1", "1")).to eq([])
        expect(described_class.
               new(coverage_map).
               tests_for_lines("file_2", "1")).to eq([])
      end
    end
  end
end
