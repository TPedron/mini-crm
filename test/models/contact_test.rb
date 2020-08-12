require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test 'Create basic contact instance' do
    contact = Contact.create!(
      first_name: expected_first_name = 'Homer',
      last_name:  expected_last_name = 'Simpson',
      email:      expected_email = 'homer.j.simpson@gmail.com'
    )

    assert contact.uuid
    assert_equal expected_first_name, contact.first_name
    assert_equal expected_last_name, contact.last_name
    assert_equal expected_email, contact.email
    assert contact.created_at
    assert contact.updated_at
  end

  test 'Can have a relationship to a Tag' do
    contact = create(:contact)
    tag = create(:tag)
    contact.tags << tag
    
    assert 1, contact.tags.count
    assert_equal tag.uuid, contact.tags.first.uuid
  end

  test 'Cannot create with nil values' do
    assert_raises ActiveRecord::RecordInvalid do
      contact = Contact.create!(
        first_name: nil,
        last_name:  nil,
        email:      nil,
        uuid:       nil
      )
    end
  end
end
