# frozen_string_literal: true

require "rails_helper"

describe Api::V1::MenuItemsController, type: :controller do
  render_views

  let_it_be(:menu) { create(:menu) }

  describe "GET #index" do
    subject(:make_a_request) { get :index, params: { menu_id: menu_id }.merge(params), format: :json }

    let_it_be(:menu_items) { create_list(:menu_item, 12, menu: menu) }
    let(:menu_id) { menu.id }

    context 'when params are provided' do
      let(:params) { { menu_id: menu.id, page: page, per_page: per_page } }

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
      let(:params) { {} }

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end
