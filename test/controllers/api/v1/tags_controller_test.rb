require 'test_helper'

class Api::V1::TagsControllerTest < ActionDispatch::IntegrationTest
  test 'POST - Create Tag successfully' do
    post '/api/v1/tags', params: {
      data: {
        type: 'tag',
        attributes: {
          name: expected_name = 'Lead'
        }
      }
    }

    assert_response :ok
    json = response.parsed_body.deep_symbolize_keys
    tag = Tag.last

    assert_equal tag.uuid, json.dig(:data, :id)
    assert_equal 'tag', json.dig(:data, :type)
    assert_equal expected_name, json.dig(:data, :attributes, :name)
    assert_equal tag.name, json.dig(:data, :attributes, :name)
  end

  test 'POST - Create Tag fails due to improper attribute' do
    post '/api/v1/tags', params: {
      data: {
        type: 'tag',
        attributes: {
          name: nil
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
          pointer: '/data/attributes/name'
        }
      }
    ]

    assert_equal expected_error_response, json
  end

  test 'GET - Index Tags successfully' do
    tag1 = create(:tag, name: 'Lead')
    tag2 = create(:tag, name: 'Churned') # should be first in list

    get '/api/v1/tags'
    assert_response :ok
    json = response.parsed_body.deep_symbolize_keys
    assert_equal 2, json.dig(:data).size
    assert_equal tag2.uuid, json.dig(:data, 0, :id)
    assert_equal tag1.uuid, json.dig(:data, 1, :id)
  end

  test 'PATCH - Update Tag successfully' do
    tag = create(:tag, name: 'Lead')

    patch "/api/v1/tags/#{tag.uuid}", params: {
      data: {
        type: 'tag',
        attributes: {
          name: expected_name = 'Friend'
        }
      }
    }

    assert_response :ok
    tag.reload
    json = response.parsed_body.deep_symbolize_keys
    assert_equal tag.uuid, json.dig(:data, :id)
    assert_equal expected_name, json.dig(:data, :attributes, :name)
    assert_equal expected_name, tag.name
  end

  test 'PATCH - Update Tag fails when not found' do
    patch "/api/v1/tags/#{SecureRandom.uuid}", params: {
      data: {
        type: 'tag',
        attributes: {
          name: 'Friend'
        }
      }
    }

    assert_response :not_found
    json = response.parsed_body.each(&:deep_symbolize_keys!)

    expected_error_response = [
      {
        status: 404,
        title: "Couldn't find Tag",
        detail: 'Tag not found'
      }
    ]

    assert_equal expected_error_response, json
  end
end
