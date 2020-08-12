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
    refute contact.deleted
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

  test 'GET - List contacts ordered by last_name ASC successfully' do
    contact_last = create(:contact, last_name: 'Zebra')
    contact_first = create(:contact, last_name: 'Apple')

    get '/api/v1/contacts'
    assert_response :ok
    json = response.parsed_body.deep_symbolize_keys

    assert json.dig(:data)
    assert_equal 2, json.dig(:data).size
    assert_equal contact_first.uuid, json.dig(:data, 0, :id)
    assert_equal contact_first.last_name, json.dig(:data, 0, :attributes, :lastName)
    assert_equal contact_last.uuid, json.dig(:data, 1, :id)
    assert_equal contact_last.last_name, json.dig(:data, 1, :attributes, :lastName)
  end

  test 'PATCH - Update Contact successfully' do
    contact = create(:contact)

    patch "/api/v1/contacts/#{contact.uuid}", params: {
      data: {
        id: contact.uuid,
        type: 'contact',
        attributes: {
          first_name: expected_first_name = 'Peter',
          last_name: expected_last_name = 'Griffin',
          email: expected_email = 'pea.tear.griffin@gmail.com'
        }
      }
    }

    assert_response :ok
    contact.reload
    json = response.parsed_body.deep_symbolize_keys

    refute contact.deleted
    assert_equal contact.uuid, json.dig(:data, :id)
    assert_equal 'contact', json.dig(:data, :type)
    assert_equal expected_first_name, json.dig(:data, :attributes, :firstName)
    assert_equal contact.first_name, json.dig(:data, :attributes, :firstName)
    assert_equal expected_last_name, json.dig(:data, :attributes, :lastName)
    assert_equal contact.last_name, json.dig(:data, :attributes, :lastName)
    assert_equal expected_email, json.dig(:data, :attributes, :email)
    assert_equal contact.email, json.dig(:data, :attributes, :email)
  end

  test 'PATCH - Update Contact fails when it cannot be found' do
    patch "/api/v1/contacts/#{uuid = SecureRandom.uuid}", params: {
      data: {
        id: uuid,
        type: 'contact',
        attributes: {
          first_name: 'Peter',
          last_name: 'Griffin',
          email: 'pea.tear.griffin@gmail.com'
        }
      }
    }

    assert_response :not_found
    json = response.parsed_body.each(&:deep_symbolize_keys!)

    expected_error_response = [
      {
        status: 404,
        title: "Couldn't find Contact",
        detail: 'Contact not found'
      }
    ]

    assert_equal expected_error_response, json
  end

  test 'DELETE - Delete Contact successfully' do
    contact = create(:contact)

    delete "/api/v1/contacts/#{contact.uuid}"

    assert_response :no_content
    contact.reload
    assert contact.deleted
  end

  test 'DELETE - Delete Contact fails when already deleted' do
    contact = create(:contact, deleted: true)

    delete "/api/v1/contacts/#{contact.uuid}"

    json = response.parsed_body.each(&:deep_symbolize_keys!)

    expected_error_response = [
      {
        status: 404,
        title: "Couldn't find Contact",
        detail: 'Contact not found'
      }
    ]

    assert_equal expected_error_response, json
  end
end
