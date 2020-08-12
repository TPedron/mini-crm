require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'Create basic tag instance' do
    tag = Tag.create!(
      name: expected_name = 'Lead'
    )

    assert tag.uuid
    assert_equal expected_name, tag.name
  end

  test 'Cannot create duplicate tags' do
    tag = Tag.create!(
      name: name = 'Lead'
    )

    assert_raises ActiveRecord::RecordInvalid do
      Tag.create!(
        name: name
      )
    end
  end

  test 'Can have a relationship with a Contact' do
    tag = create(:tag)
    contact = create(:contact)
    tag.contacts << contact

    assert 1, tag.contacts.count
    assert_equal contact.uuid, tag.contacts.first.uuid
  end
end
