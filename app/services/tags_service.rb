class TagsService
  def find_or_create_tag(tag_dto)
    Tag.find_or_create_by!(
      name: tag_dto.name
    )
  end

  def list_tags
    # NOTE: Pagination would be implemented here.
    Tag.order(name: :asc)
  end

  def find_and_update_tag(tag_dto)
    tag = find_tag(tag_dto)
    # NOTE: Logic below ensures we do not allow setting values to nil
    tag.update!(
      name: tag_dto.name || tag.name
    )

    tag
  end

  private

  def find_tag(tag_dto)
    Tag.find_by_uuid!(tag_dto.uuid)
  end
end
