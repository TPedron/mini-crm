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
end
