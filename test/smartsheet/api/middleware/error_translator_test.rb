require_relative '../../../test_helper'
require 'smartsheet/api/middleware/error_translator'
require 'mocha'

describe Smartsheet::API::Middleware::ErrorTranslator do
  it 'wraps Faraday errors raised during request handling' do
    failure_message = 'Failure'
    app = mock
    app.stubs(:call).raises(Faraday::Error, failure_message)
    error_translator = Smartsheet::API::Middleware::ErrorTranslator.new(app)

    -> { error_translator.call('Environment') }.must_raise Smartsheet::API::Error
  end

  it 'passes through with no effect when no error is raised' do
    env = { key: 'value' }.freeze
    app = mock
    app.expects(:call)
    error_translator = Smartsheet::API::Middleware::ErrorTranslator.new(app)
    error_translator.call(env) # Changes to env violate frozen hash
  end
end