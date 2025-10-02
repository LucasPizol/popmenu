# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MenuItemsController, type: :request, swagger_doc: 'api/swagger.yaml' do
  path '/api/v1/restaurants/{restaurant_id}/menus/{menu_id}/menu_items' do
    get 'Loads all menu items' do
      tags 'Menu Items'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :menu_id, in: :path, type: :string
      parameter name: :restaurant_id, in: :path, type: :string

      let_it_be(:menu) { create(:menu) }
      let_it_be(:menu_items) { create_list(:menu_item, 12, menu: menu) }

      response '200', 'Menu items loaded' do
        let(:menu_id) { menu.id }
        let(:restaurant_id) { menu.restaurant.id }

        it_behaves_like 'run request test'
      end

      response '404', 'Menu or restaurant not found' do
        let(:menu_id) { 'invalid' }
        let(:restaurant_id) { menu.restaurant.id }

        run_test!
      end
    end
  end
end
