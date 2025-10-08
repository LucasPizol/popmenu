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
          { errors: nil, message: "Burger created and was correctly associated to 'lunch'", status: "success" },
          { errors: nil, message: "Small Salad created and was correctly associated to 'lunch'", status: "success" },
          { errors: nil, message: "Burger already exists and was correctly associated to 'dinner'", status: "success" },
          { errors: nil, message: "Large Salad created and was correctly associated to 'dinner'", status: "success" },
          { errors: nil, message: "Chicken Wings created and was correctly associated to 'lunch'", status: "success" },
          { errors: [ "Name has already been taken" ], message: "Burger not created", status: "error" },
          { errors: nil, message: "Chicken Wings already exists and was correctly associated to 'lunch'", status: "success" },
          { errors: nil, message: "Mega \"Burger\" created and was correctly associated to 'dinner'", status: "success" },
          { errors: nil, message: "Lobster Mac & Cheese created and was correctly associated to 'dinner'", status: "success" }
        ])
    end
  end
end
