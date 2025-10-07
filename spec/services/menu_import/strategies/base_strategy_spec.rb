# frozen_string_literal: true

require 'rails_helper'

describe MenuImport::Strategies::BaseStrategy, :unit do
  let(:file_path) { Rails.root.join('spec/fixtures/files/menu_import/file.json') }
  let(:strategy) { described_class.new(file_path) }

  describe '#import' do
    it 'raises an error' do
      expect { strategy.import }.to raise_error(NotImplementedError)
    end
  end

  describe '#file_content' do
    let(:file_content) { File.read(Rails.root.join('spec/fixtures/files/menu_import/file.json')) }

    it 'returns the file content' do
      expect(strategy.send(:file_content)).to eq(file_content)
    end
  end
end
