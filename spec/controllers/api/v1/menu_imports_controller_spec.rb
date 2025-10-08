# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::MenuImportsController, :request do
  describe '#create' do
    subject(:make_a_request) { post :create, params: { file: fixture_file_upload('menu_import/file.json') } }

    it { is_expected.to have_http_status(:ok) }

    it 'imports the menu' do
      make_a_request

      expect(json_response).to eq(
        [
          { errors: nil, message: "Menu item created: Burger", status: "success" },
          { errors: nil, message: "Menu item created: Small Salad", status: "success" },
          { errors: nil, message: "Menu item created: Burger", status: "success" },
          { errors: nil, message: "Menu item created: Large Salad", status: "success" },
          { errors: nil, message: "Menu item created: Chicken Wings", status: "success" },
          { errors: [ "Name has already been taken" ], message: "Menu item not created: Burger", status: "error" },
          { errors: nil, message: "Menu item created: Chicken Wings", status: "success" },
          { errors: nil, message: "Menu item created: Mega \"Burger\"", status: "success" },
          { errors: nil, message: "Menu item created: Lobster Mac & Cheese", status: "success" }
        ])
    end
  end
end
