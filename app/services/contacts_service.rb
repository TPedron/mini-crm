class ContactsService
  def create_contact(contact_dto)
    Contact.create!(
      first_name: contact_dto.first_name,
      last_name: contact_dto.last_name,
      email: contact_dto.email
    )
  end
end
