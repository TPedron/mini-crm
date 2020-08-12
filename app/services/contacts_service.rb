class ContactsService
  def create_contact(contact_dto)
    contact = Contact.create!(
      first_name: contact_dto.first_name,
      last_name: contact_dto.last_name,
      email: contact_dto.email
    )

    set_tags(contact, contact_dto.tag_names) if contact_dto.tag_names.present?

    contact
  end

  def list_contacts
    # NOTE: Pagination would be implemented here.
    Contact.where(
      deleted: false
    ).order(
      last_name: :asc,
      first_name: :asc
    )
  end

  def find_and_update_contact(contact_dto)
    contact = find_contact(contact_dto)
    # NOTE: Logic below ensures we do not allow setting values to nil
    contact.update!(
      first_name: contact_dto.first_name || contact.first_name,
      last_name: contact_dto.last_name || contact.last_name,
      email: contact_dto.email || contact.email
    )

    set_tags(contact, contact_dto.tag_names) if contact_dto.tag_names.present?

    contact
  end

  def find_and_soft_delete_contact(contact_dto)
    contact = find_contact(contact_dto)

    contact.update!(
      deleted: true
    )

    contact
  end

  private

  def find_contact(contact_dto)
    Contact.find_by!(
      uuid: contact_dto.uuid,
      deleted: false
    )
  end

  def set_tags(contact, tag_names)
    present_tags = contact.tags
    tags = retrieve_tags(tag_names)

    add_new_tags(contact, tags - present_tags)
    remove_existing_tags(contact, present_tags - tags)
  end

  def retrieve_tags(tag_names)
    tag_names.map do |tag_name|
      Tag.find_or_create_by!(
        name: tag_name
      )
    end
  end

  def add_new_tags(contact, tags)
    tags.each do |curr_tag|
      contact.tags << curr_tag
    end
  end

  def remove_existing_tags(contact, tags)
    tags.each do |curr_tag|
      contact.tags.delete(curr_tag)
    end
  end
end
