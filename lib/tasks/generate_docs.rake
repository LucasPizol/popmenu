task :docs do
  ENV['SWAGGER_DRY_RUN'] = '0'
  ENV['PATTERN'] = 'spec/requests/**/*_spec.rb'

  Rake::Task['rswag:specs:swaggerize'].execute
end
