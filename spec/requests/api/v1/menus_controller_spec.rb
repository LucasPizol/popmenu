# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MenusController, type: :request, swagger_doc: 'api/swagger.yaml' do
  path '/api/v1/menus' do
    get 'Loads all menus' do
      tags 'Menus'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'

      let_it_be(:menus) { create_list(:menu, 12) }

      response '200', 'Menus loaded' do
        it_behaves_like 'run request test'
      end
    end
  end

  path '/api/v1/menus/{id}' do
    get 'Loads a menu' do
      tags 'Menus'
      security [Bearer: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      let_it_be(:menu) { create(:menu) }

      response '200', 'Menu loaded' do
        let(:id) { menu.id }

        it_behaves_like 'run request test'
      end

      response '404', 'Menu not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
