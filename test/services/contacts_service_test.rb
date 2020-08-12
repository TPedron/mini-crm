require 'test_helper'

class ContactsServiceTest < ActiveSupport::TestCase
  setup do
    @contacts_service = ContactsService.new
  end

  test '#create_contact - builds and returns a contact' do
    contact_dto = build_contact_dto(
      uuid: nil,
      first_name: expected_first_name = 'Homer',
      last_name: expected_last_name = 'Simpson',
      email: expected_email = 'homer.j.simpson@gmail.com',
      tag_names: nil
    )

    contact = @contacts_service.create_contact(contact_dto)

    assert contact
    assert_equal expected_first_name, contact.first_name
    assert_equal expected_last_name, contact.last_name
    assert_equal expected_email, contact.email
    assert contact.uuid
    assert contact.created_at
    assert contact.updated_at
    refute contact.deleted
  end

  test '#create_contact - associates provided tag_names to Tags' do
    lead_tag = create(:tag, name: 'Lead')
    contact_dto = build_contact_dto(
      uuid: nil,
      first_name: expected_first_name = 'Homer',
      last_name: expected_last_name = 'Simpson',
      email: expected_email = 'homer.j.simpson@gmail.com',
      tag_names: [lead_tag.name, 'Friend']
    )

    contact = @contacts_service.create_contact(contact_dto)
    friend_tag = Tag.last

    assert contact
    assert_equal expected_first_name, contact.first_name
    assert_equal expected_last_name, contact.last_name
    assert_equal expected_email, contact.email
    assert_equal [lead_tag.name, friend_tag.name], contact.tag_names
    assert contact.uuid
    assert contact.created_at
    assert contact.updated_at
    refute contact.deleted
  end

  test '#create_contact - raises a RecordInvalid error when attribute validation fails' do
    contact_dto = build_contact_dto(
      uuid: nil,
      first_name: 'Homer',
      last_name: nil, # NOTE: last_name is required
      email: 'homer.j.simpson@gmail.com',
      tag_names: []
    )

    assert_raises ActiveRecord::RecordInvalid do
      @contacts_service.create_contact(contact_dto)
    end
  end

  test '#list_contacts - returns a list of all Contacts sorted by last_name & first_name ASC' do
    contact_last = create(:contact, last_name: 'Zebra')
    contact_middle = create(:contact, first_name: 'Tom', last_name: 'Apple')
    contact_first = create(:contact, first_name: 'Alan', last_name: 'Apple')

    contacts = @contacts_service.list_contacts
    assert_equal 3, contacts.size
    assert_equal contact_first, contacts.first
    assert_equal contact_middle, contacts.second
    assert_equal contact_last, contacts.last
  end

  test '#list_contacts - allows for search based on tag name' do
    contact_last = create(:contact, last_name: 'Zebra')
    contact_first = create(:contact, last_name: 'Apple')
    create(:contact) # not returned in search
    tag = create(:tag)
    contact_last.tags << tag
    contact_first.tags << tag

    contacts = @contacts_service.list_contacts(tag.name)
    assert_equal 2, contacts.size
    assert_equal contact_first, contacts.first
    assert_equal contact_last, contacts.last
  end

  test '#list_contacts - returns empty list when tag does not exist' do
    create(:contact)

    contacts = @contacts_service.list_contacts('Tag Does Not Exist')
    assert contacts.empty?
  end

  test '#find_and_update_contact - find the contact and updates attributes & tags' do
    lead_tag = create(:tag, name: 'Lead')
    contact = create(:contact)
    contact.tags << lead_tag
    contact_dto = build_contact_dto(
      uuid: contact.uuid,
      first_name: expected_first_name = 'Homer',
      last_name: expected_last_name = 'Simpson',
      email: expected_email = 'homer.j.simpson@gmail.com',
      tag_names: ['Friend']
    )

    updated_contact = @contacts_service.find_and_update_contact(contact_dto)
    friend_tag = Tag.last
    assert_equal contact.uuid, updated_contact.uuid
    assert_equal expected_first_name, updated_contact.first_name
    assert_equal expected_last_name, updated_contact.last_name
    assert_equal expected_email, updated_contact.email
    assert_equal [friend_tag.name], contact.tag_names
    refute updated_contact.deleted
  end

  test '#find_and_update_contact - fails to find the contact' do
    contact_dto = build_contact_dto(
      uuid: SecureRandom.uuid,
      first_name: 'Homer',
      last_name: 'Simpson',
      email: 'homer.j.simpson@gmail.com',
      tag_names: []
    )

    assert_raises ActiveRecord::RecordNotFound do
      @contacts_service.find_and_update_contact(contact_dto)
    end
  end

  test '#find_and_update_contact - find the contact and soft-delete' do
    contact = create(:contact)
    contact_dto = build_contact_dto(
      uuid: contact.uuid,
      first_name: nil,
      last_name: nil,
      email: nil,
      tag_names: nil
    )

    updated_contact = @contacts_service.find_and_soft_delete_contact(contact_dto)
    assert_equal contact.uuid, updated_contact.uuid
    assert updated_contact.deleted
  end

  private

  def build_contact_dto(uuid:, first_name:, last_name:, email:, tag_names:)
    contact_dto = ContactDto.new({})
    contact_dto.uuid = uuid
    contact_dto.first_name = first_name
    contact_dto.last_name = last_name
    contact_dto.email = email
    contact_dto.tag_names = tag_names
    contact_dto
  end
end
