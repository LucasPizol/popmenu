Rswag::Api.configure do |c|
  c.openapi_root = Rails.root.to_s + '/swagger'
  c.swagger_headers = { 'Content-Type' => 'application/json; charset=UTF-8' }
end

Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/api/swagger.yaml', 'API V1 Docs'
end
