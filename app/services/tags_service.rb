class TagsService
  def find_or_create_tag(tag_dto)
    Tag.find_or_create_by!(
      name: tag_dto.name
    )
  end
end
