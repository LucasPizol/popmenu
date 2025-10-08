# frozen_string_literal: true

require "rails_helper"

describe Api::V1::MenusController, type: :controller do
  render_views

  describe "GET #index" do
    before_all { create(:menu, restaurant: create(:restaurant)) }

    subject(:make_a_request) { get :index, params: { restaurant_id: restaurant_id }.merge(params), format: :json }

    let_it_be(:restaurant) { create(:restaurant) }
    let_it_be(:menus) { create_list(:menu, 12, restaurant: restaurant) }
    let(:restaurant_id) { restaurant.id }
    let(:params) { {} }

    context 'when params are provided' do
      let(:params) { { page: page, per_page: per_page } }

      context 'when page is one' do
        let(:page) { 1 }
        let(:per_page) { 10 }

        it { is_expected.to have_http_status(:success) }

        it "returns the correct number of menus" do
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

        it "returns the correct number of menus" do
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

      it "returns the correct number of menus" do
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

    context 'when restaurant is not found' do
      let(:restaurant_id) { 'invalid' }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe "GET #show" do
    subject(:make_a_request) { get :show, params: { restaurant_id: restaurant_id, id: id }, format: :json }

    let_it_be(:menu) { create(:menu) }
    let_it_be(:restaurant) { menu.restaurant }

    let(:restaurant_id) { restaurant.id }
    let(:id) { menu.id }

    context 'when success' do
      it { is_expected.to have_http_status(:success) }

      it "returns the correct menu" do
        make_a_request

        expect(json_response[:menu]).to match({
          id: menu.id,
          name: menu.name,
          description: menu.description,
          createdAt: a_kind_of(String),
          updatedAt: a_kind_of(String),
          menuItems: api_v1_restaurant_menu_menu_items_path(menu.restaurant, menu)
        })
      end
    end

    context 'when error' do
      context 'when menu is not found' do
        let(:id) { 'invalid' }

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
end
