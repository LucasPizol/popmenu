# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::MenuImportsController, :request do
  path '/api/v1/menu_imports' do
    post 'Creates a menu import' do
      tags 'Menu Imports'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :file, in: :formData, schema: { type: :file }

      response '200', 'Menu import created' do
        let(:file) { fixture_file_upload('menu_import/file.json') }

        it_behaves_like 'run request test'
      end

      response '422', 'Menu import not created' do
        let(:file) { fixture_file_upload('menu_import/invalid.invalid') }

        it_behaves_like 'run request test'
      end
    end
  end
end
