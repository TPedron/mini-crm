require 'test_helper'

class TagsServiceTest < ActiveSupport::TestCase
  setup do
    @tags_service = TagsService.new
  end

  test '#find_or_create_tag - builds and returns a new Tag' do
    tag_dto = build_tag_dto(
      uuid: nil,
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
      uuid: nil,
      name: tag.name
    )

    returned_tag = @tags_service.find_or_create_tag(tag_dto)

    assert returned_tag
    assert_equal returned_tag.uuid, tag.uuid
    assert_equal returned_tag.name, tag.name
  end

  test '#find_and_update_tag - builds and returns an existing Tag' do
    tag = create(:tag)
    tag_dto = build_tag_dto(
      uuid: tag.uuid,
      name: new_name = 'Lead'
    )

    contact = create(:contact)
    contact.tags << tag

    returned_tag = @tags_service.find_and_update_tag(tag_dto)

    assert returned_tag
    assert_equal returned_tag.uuid, tag.uuid
    assert_equal new_name, returned_tag.name

    # Ensure tag is still associated to contact
    contact.reload
    assert_equal new_name, contact.tags.first.name
  end

  test '#find_and_delete_tag deletes the tag' do
    tag = create(:tag)
    contact = create(:contact)
    contact.tags << tag

    tag_dto = build_tag_dto(
      uuid: tag.uuid,
      name: nil
    )

    assert_nothing_raised do
      @tags_service.find_and_delete_tag(tag_dto)
    end

    contact.reload
    assert contact.tags.empty?
  end

  private

  def build_tag_dto(uuid:, name:)
    tag_dto = TagDto.new({})
    tag_dto.uuid = uuid
    tag_dto.name = name
    tag_dto
  end
end
