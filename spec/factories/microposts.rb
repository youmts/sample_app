FactoryBot.define do
  factory :micropost do
    association :user
    content { Faker::Lorem.sentence(5)}
  end
end