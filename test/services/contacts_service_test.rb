require 'test_helper'

class ContactsServiceTest < ActiveSupport::TestCase
  setup do
    @contacts_service = ContactsService.new
  end

  test '#create_contact - builds and returns a contact' do
    contact_dto = build_contact_dto(
      first_name: expected_first_name = 'Homer',
      last_name: expected_last_name = 'Simpson',
      email: expected_email = 'homer.j.simpson@gmail.com'
    )

    contact = @contacts_service.create_contact(contact_dto)

    assert contact
    assert_equal expected_first_name, contact.first_name
    assert_equal expected_last_name, contact.last_name
    assert_equal expected_email, contact.email
    assert contact.uuid
    assert contact.created_at
    assert contact.updated_at
  end

  test '#create_contact - raises a RecordInvalid error when attribute validation fails' do
    contact_dto = build_contact_dto(
      first_name: 'Homer',
      last_name: nil, # NOTE: last_name is required
      email: 'homer.j.simpson@gmail.com'
    )

    assert_raises ActiveRecord::RecordInvalid do
      @contacts_service.create_contact(contact_dto)
    end
  end

  private

  def build_contact_dto(first_name:, last_name:, email:)
    contact_dto = ContactDto.new({})
    contact_dto.first_name = first_name
    contact_dto.last_name = last_name
    contact_dto.email = email
    contact_dto
  end
end
