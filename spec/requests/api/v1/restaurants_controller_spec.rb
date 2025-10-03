# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RestaurantsController, type: :request, swagger_doc: 'api/swagger.yaml' do
  path '/api/v1/restaurants' do
    get 'Loads all restaurants' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'

      let_it_be(:restaurants) { create_list(:restaurant, 12) }

      response '200', 'Restaurants loaded' do
        it_behaves_like 'run request test'
      end
    end

    post 'Creates a restaurant' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :restaurant_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Lorem.word },
          description: { type: :string, example: Faker::Lorem.sentence }
        }
      }

      response '201', 'Restaurant created' do
        let(:restaurant_params) { { name: Faker::Lorem.word, description: Faker::Lorem.sentence } }

        it_behaves_like 'run request test'
      end

      response '422', 'Restaurant not created' do
        let(:restaurant_params) { { name: '', description: '' } }

        it_behaves_like 'run request test'
      end
    end
  end

  path '/api/v1/restaurants/{id}' do
    get 'Loads a restaurant' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      let_it_be(:restaurant) { create(:restaurant) }

      response '200', 'Restaurant loaded' do
        let(:id) { restaurant.id }

        it_behaves_like 'run request test'
      end

      response '404', 'Restaurant not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end

    put 'Updates a restaurant' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      parameter name: :restaurant_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Lorem.word },
          description: { type: :string, example: Faker::Lorem.sentence }
        }
      }

      let_it_be(:restaurant) { create(:restaurant) }

      response '200', 'Restaurant updated' do
        let(:id) { restaurant.id }
        let(:restaurant_params) { { name: Faker::Lorem.word, description: Faker::Lorem.sentence } }

        it_behaves_like 'run request test'
      end

      response '404', 'Restaurant not found' do
        let(:id) { 'invalid' }
        let(:restaurant_params) { { name: Faker::Lorem.word, description: Faker::Lorem.sentence } }

        run_test!
      end

      response '422', 'Restaurant not updated' do
        let(:id) { restaurant.id }
        let(:restaurant_params) { { name: '', description: '' } }

        it_behaves_like 'run request test'
      end
    end

    delete 'Deletes a restaurant' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      response '204', 'Restaurant deleted' do
        let!(:restaurant) { create(:restaurant) }
        let(:id) { restaurant.id }

        run_test!
      end

      response '404', 'Restaurant not found' do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
