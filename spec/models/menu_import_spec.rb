# frozen_string_literal: true

require 'rails_helper'

describe MenuImport, :unit do
  let(:file_path) { Rails.root.join('spec/support/menu_import/file.json') }
  let(:menu_import) { described_class.new(file_path: file_path) }

  describe '#import' do
    before { allow(MenuImport::Factory).to receive(:new).and_return(double(create_strategy: double(import: true))) }


    context 'when the file path is valid' do
      it 'calls the factory to create the strategy' do
        menu_import.import

        expect(MenuImport::Factory).to have_received(:new).with(file_path.to_s)
      end
    end

    context 'when the file path is invalid' do
      let(:file_path) { 'invalid.txt' }

      it 'assigns an error to the file path' do
        menu_import.import

        expect(menu_import.errors[:file_path]).to eq([ "must be a valid file type" ])
      end

      it 'does not call the factory to create the strategy' do
        menu_import.import

        expect(MenuImport::Factory).not_to have_received(:new).with(file_path.to_s)
      end
    end
  end
end
