puts 'Seeding Database'

puts 'Adding Tags'

lead_tag = Tag.find_or_create_by!(
  name: 'Lead'
)

high_value_tag = Tag.find_or_create_by!(
  name: 'HighValue'
)

finalized_tag = Tag.find_or_create_by!(
  name: 'Finalized'
)

stage2_tag = Tag.find_or_create_by!(
  name: 'Stage2'
)

low_value_tag = Tag.find_or_create_by!(
  name: 'LowValue'
)

churned_tag = Tag.find_or_create_by!(
  name: 'Churned'
)

real_estate_tag = Tag.find_or_create_by!(
  name: 'RealEstate'
)

puts 'Adding Contacts And Associating Tags'

contact1 = Contact.find_or_create_by!(
  first_name: 'Andrew',
  last_name: 'Stevens',
  email: 'andrew@company.com'
)

unless contact1.tags.any?
  contact1.tags << lead_tag
  contact1.tags << high_value_tag
  contact1.tags << finalized_tag
end

contact2 = Contact.find_or_create_by!(
  first_name: 'Bob',
  last_name: 'Rodriguez',
  email: 'bob@yahoo.com'
)

unless contact2.tags.any?
  contact2.tags << lead_tag
  contact2.tags << stage2_tag
  contact2.tags << low_value_tag
end

contact3 = Contact.find_or_create_by!(
  first_name: 'Cathy',
  last_name: 'Smith',
  email: 'cathy@lycos.com'
)

unless contact3.tags.any?
  contact3.tags << churned_tag
  contact3.tags << finalized_tag
  contact3.tags << real_estate_tag
end
