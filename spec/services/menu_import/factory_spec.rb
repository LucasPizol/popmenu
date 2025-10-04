# frozen_string_literal: true

require 'rails_helper'

describe MenuImport::Factory, :unit do
  let(:file_path) { "test.json" }
  let(:factory) { described_class.new(file_path) }

  describe "#create_strategy" do
    context "when the file path is a json file" do
      it "returns the correct strategy" do
        expect(factory.create_strategy).to be_a(MenuImport::Strategies::JsonStrategy)
      end

      it 'sets the file extension' do
        factory.create_strategy

        expect(factory.send("file_extension")).to eq("json")
      end
    end

    context "when the file path is invalid" do
      let(:file_path) { "test.invalid" }

      it "raises an error" do
        expect { factory.create_strategy }.to raise_error(RuntimeError, "Invalid file type: invalid")
      end
    end
  end
end
