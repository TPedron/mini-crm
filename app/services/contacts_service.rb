class ContactsService
  def create_contact(contact_dto)
    Contact.create!(
      first_name: contact_dto.first_name,
      last_name: contact_dto.last_name,
      email: contact_dto.email
    )
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
end
