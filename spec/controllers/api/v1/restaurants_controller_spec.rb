# frozen_string_literal: true

require "rails_helper"

describe Api::V1::RestaurantsController, type: :controller do
  render_views

  describe "GET #index" do
    subject(:make_a_request) { get :index, params: params, format: :json }

    let_it_be(:restaurants) { create_list(:restaurant, 12) }
    let(:params) { {} }

    context 'when params are provided' do
      let(:params) { { page: page, per_page: per_page } }

      context 'when page is one' do
        let(:page) { 1 }
        let(:per_page) { 10 }

        it { is_expected.to have_http_status(:success) }

        it "returns the correct number of restaurants" do
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

        it "returns the correct number of restaurants" do
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

      it "returns the correct number of restaurants" do
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

  describe "GET #show" do
    subject(:make_a_request) { get :show, params: { id: id }, format: :json }

    let_it_be(:restaurant) { create(:restaurant) }

    let(:id) { restaurant.id }

    context 'when success' do
      it { is_expected.to have_http_status(:success) }

      it "returns the correct restaurant" do
        make_a_request

        expect(json_response[:restaurant]).to match({
          id: restaurant.id,
          name: restaurant.name,
          description: restaurant.description,
          createdAt: a_kind_of(String),
          updatedAt: a_kind_of(String)
        })
      end
    end

    context 'when error' do
      context 'when restaurant is not found' do
        let(:id) { 'invalid' }

        it { is_expected.to have_http_status(:not_found) }
      end
    end
  end

  describe 'POST #create' do
    subject(:make_a_request) { post :create, params: params, format: :json }

    let(:params) { { restaurant: { name: name, description: description } } }
    let(:name) { Faker::Lorem.word }
    let(:description) { Faker::Lorem.sentence }

    context 'when success' do
      it { is_expected.to have_http_status(:created) }

      it { expect { make_a_request }.to change(Restaurant, :count).by(1) }

      it "returns the correct restaurant" do
        make_a_request

        expect(json_response[:restaurant]).to match({
          id: a_kind_of(Integer),
          name: name,
          description: description,
          createdAt: a_kind_of(String),
          updatedAt: a_kind_of(String)
        })
      end
    end

    context 'when error' do
      context 'when name is not present' do
        let(:name) { nil }

        it { is_expected.to have_http_status(:unprocessable_entity) }

        it "returns the correct errors" do
          errors = Restaurant.new.errors

          make_a_request

          expect(json_response[:errors]).to eq({ name: [ errors.generate_message(:name, :blank) ] })
        end
      end

      context 'when description is too long' do
        let(:description) { Faker::Lorem.paragraph(sentence_count: 1000) }

        it { is_expected.to have_http_status(:unprocessable_entity) }

        it "returns the correct errors" do
          errors = Restaurant.new.errors

          make_a_request

          expect(json_response[:errors]).to eq({ description: [ errors.generate_message(:description, :too_long, count: 1000) ] })
        end
      end
    end
  end

  describe 'PUT #update' do
    subject(:make_a_request) { put :update, params: params, format: :json }

    let(:restaurant) { create(:restaurant) }
    let(:id) { restaurant.id }

    let(:params) { { id: id, restaurant: { name: name, description: description } } }
    let(:name) { Faker::Lorem.word }
    let(:description) { Faker::Lorem.sentence }

    context 'when success' do
      it { is_expected.to have_http_status(:ok) }

      it { expect { make_a_request }.to change { restaurant.reload.name }.to(name) }

      it { expect { make_a_request }.to change { restaurant.reload.description }.to(description) }
    end

    context 'when error' do
      context 'when name is not present' do
        let(:name) { nil }

        it { is_expected.to have_http_status(:unprocessable_entity) }

        it "returns the correct errors" do
          errors = Restaurant.new.errors

          make_a_request

          expect(json_response[:errors]).to eq({ name: [ errors.generate_message(:name, :blank) ] })
        end
      end

      context 'when description is too long' do
        let(:description) { Faker::Lorem.paragraph(sentence_count: 1000) }

        it { is_expected.to have_http_status(:unprocessable_entity) }

        it "returns the correct errors" do
          errors = Restaurant.new.errors

          make_a_request

          expect(json_response[:errors]).to eq({ description: [ errors.generate_message(:description, :too_long, count: 1000) ] })
        end
      end

      context 'when restaurant is not found' do
        let(:id) { 'invalid' }

        it { is_expected.to have_http_status(:not_found) }
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:make_a_request) { delete :destroy, params: { id: id }, format: :json }

    let!(:restaurant) { create(:restaurant) }
    let(:id) { restaurant.id }

    context 'when success' do
      it { is_expected.to have_http_status(:no_content) }

      it { expect { make_a_request }.to change(Restaurant, :count).by(-1) }
    end

    context 'when error' do
      context 'when restaurant is not found' do
        let(:id) { 'invalid' }

        it { is_expected.to have_http_status(:not_found) }
      end
    end
  end
end
