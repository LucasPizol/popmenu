# frozen_string_literal: true

require "rails_helper"

describe Api::V1::MenusController, type: :controller do
  render_views

  subject(:make_a_request) { get :index, params: params, format: :json }

  describe "GET #index" do
    let_it_be(:menus) { create_list(:menu, 12) }

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
  end
end
