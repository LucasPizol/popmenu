# frozen_string_literal: true

RSpec.shared_examples 'run request test' do
  after do |example|
    example.metadata[:response][:content] = {
      'application/json' => {
        example: JSON.parse(response.body, symbolize_names: true)
      }
    }
  end

  run_test!
end
