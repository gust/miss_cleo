require 'spec_helper'

describe MissCleo::TemplateHelper do

  describe "#template_coverage" do

    it "initializes an empty array" do
      expect(described_class.template_coverage).to match_array([])
    end

  end

  describe "#add_to_template_coverage" do
    it "adds templates with a trimmed path to the coverage" do
      template_path = "#{`pwd`.chomp}/template.haml"
      described_class.add_to_template_coverage(template_path)
      expect(described_class.template_coverage).to match_array(["template.haml"])
    end
  end

  # in testing this, it becomes apparent that relying on a floating
  # ivar isn't a good idea. If it's hard to test, then it's going to
  # cause trouble later on.
  describe "#reset_coverage" do
    it "empties the template_coverage array" do
      expect(described_class.template_coverage.count).to eq(1)
      described_class.reset_coverage
      expect(described_class.template_coverage.count).to eq(0)
    end
  end

end
