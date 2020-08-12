require 'test_helper'

class TagsServiceTest < ActiveSupport::TestCase
  setup do
    @tags_service = TagsService.new
  end

  test '#find_or_create_tag - builds and returns a new Tag' do
    tag_dto = build_tag_dto(
      name: expected_name = 'Lead'
    )

    tag = @tags_service.find_or_create_tag(tag_dto)

    assert tag
    assert_equal expected_name, tag.name
    assert tag.uuid
    assert tag.created_at
    assert tag.updated_at
  end

  test '#find_or_create_tag - builds and returns an existing Tag' do
    tag = create(:tag)
    tag_dto = build_tag_dto(
      name: tag.name
    )

    returned_tag = @tags_service.find_or_create_tag(tag_dto)

    assert returned_tag
    assert_equal returned_tag.uuid, tag.uuid
    assert_equal returned_tag.name, tag.name
  end

  private

  def build_tag_dto(name:)
    tag_dto = TagDto.new({})
    tag_dto.name = name
    tag_dto
  end
end
