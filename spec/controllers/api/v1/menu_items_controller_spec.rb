# frozen_string_literal: true

require "rails_helper"

describe Api::V1::MenuItemsController, type: :controller do
  render_views

  let_it_be(:menu) { create(:menu) }
  let_it_be(:restaurant) { menu.restaurant }

  describe "GET #index" do
    subject(:make_a_request) { get :index, params: { menu_id: menu_id, restaurant_id: restaurant_id }.merge(params), format: :json }

    let_it_be(:menu_items) { create_list(:menu_item, 12, restaurant: restaurant) }

    before_all do
      menu_items.each do |menu_item|
        create(:menu_association, menu: menu, menu_item: menu_item)
      end
    end

    let(:menu_id) { menu.id }
    let(:restaurant_id) { restaurant.id }
    let(:params) { {} }

    context 'when params are provided' do
      let(:params) { { page: page, per_page: per_page } }

      context 'when page is one' do
        let(:page) { 1 }
        let(:per_page) { 10 }

        it { is_expected.to have_http_status(:success) }

        it "returns the correct number of menu items" do
          make_a_request

          expect(json_response[:data].size).to eq(10)
        end

        it "returns the correct meta" do
          make_a_request

          expect(json_response[:meta]).to eq({
            currentPage: 1,
            totalPages: 2,
            totalCount: 12
          })
        end
      end

      context 'when page is two' do
        let(:page) { 2 }
        let(:per_page) { 10 }

        it { is_expected.to have_http_status(:success) }

        it "returns the correct number of menu items" do
          make_a_request

          expect(json_response[:data].size).to eq(2)
        end

        it "returns the correct meta" do
          make_a_request

          expect(json_response[:meta]).to eq({
            currentPage: 2,
            totalPages: 2,
            totalCount: 12
          })
        end
      end
    end

    context 'when params are not provided' do
      let(:params) { {} }

      it { is_expected.to have_http_status(:success) }

      it "returns the correct number of menu items" do
        make_a_request

        expect(json_response[:data].size).to eq(10)
      end


      it "returns the correct meta" do
        make_a_request

        expect(json_response[:meta]).to eq({
          currentPage: 1,
          totalPages: 2,
          totalCount: 12
        })
      end
    end

    context 'when menu is not found' do
      let(:menu_id) { 'invalid' }

      it { is_expected.to have_http_status(:not_found) }
    end

    context 'when restaurant is not found' do
      let(:restaurant_id) { 'invalid' }

      it { is_expected.to have_http_status(:not_found) }
    end

    context 'when menu is not from the restaurant' do
      let(:other_restaurant) { create(:restaurant) }
      let(:restaurant_id) { other_restaurant.id }

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end
