require 'spec_helper'

describe MissCleo::TemplateTracker do

  describe "#initialize_tracker" do
    it "initializes an empty array" do
      described_class.initialize_tracker
      expect(described_class.templates).to match_array([])
    end
  end

  describe "#add_to_template_coverage" do
    it "adds templates with a trimmed path to the coverage" do
      template_path = "#{`pwd`.chomp}/template.haml"
      described_class.initialize_tracker
      described_class.add_to_template_coverage(template_path)
      expect(described_class.templates).to match_array(["template.haml"])
    end
  end

  describe "#clear_templates" do
    it "clears templates" do
      described_class.initialize_tracker
      template_path = "#{`pwd`.chomp}/template.haml"
      described_class.add_to_template_coverage(template_path)
      expect(described_class.templates).to match_array(["template.haml"])
      described_class.clear_templates
      expect(described_class.templates.count).to eq(0)
    end
  end

end
