require 'test_helper'

class Api::V1::ContactsControllerTest < ActionDispatch::IntegrationTest
  test 'POST - Create Contact successfully' do
    post '/api/v1/contacts', params: {
      data: {
        type: 'contact',
        attributes: {
          first_name: expected_first_name = 'Homer',
          last_name: expected_last_name = 'Simpson',
          email: expected_email = 'homer.j.simpson@gmail.com'
        }
      }
    }

    assert_response :created
    json = response.parsed_body.deep_symbolize_keys
    contact = Contact.last

    assert_equal contact.uuid, json.dig(:data, :id)
    assert_equal 'contact', json.dig(:data, :type)
    assert_equal expected_first_name, json.dig(:data, :attributes, :firstName)
    assert_equal contact.first_name, json.dig(:data, :attributes, :firstName)
    assert_equal expected_last_name, json.dig(:data, :attributes, :lastName)
    assert_equal contact.last_name, json.dig(:data, :attributes, :lastName)
    assert_equal expected_email, json.dig(:data, :attributes, :email)
    assert_equal contact.email, json.dig(:data, :attributes, :email)
  end

  test 'POST - Create Contact fails due to improper attribute' do
    post '/api/v1/contacts', params: {
      data: {
        type: 'contact',
        attributes: {
          first_name: nil,
          last_name: 'Simpson',
          email: 'homer.j.simpson@gmail.com'
        }
      }
    }

    assert_response :unprocessable_entity
    json = response.parsed_body.each(&:deep_symbolize_keys!)

    expected_error_response = [
      {
        status: 422,
        title: "can't be blank",
        source: {
          pointer: '/data/attributes/firstName'
        }
      }
    ]

    assert_equal expected_error_response, json
  end
end
