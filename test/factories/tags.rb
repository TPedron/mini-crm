FactoryBot.define do
  factory :tag do
    uuid { SecureRandom.uuid }
    name { Faker::Creature::Cat.breed }
  end
end
