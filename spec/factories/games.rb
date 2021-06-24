FactoryBot.define do
  factory :game do
    mode { %i(pvp pve both).sample }
    release_date { "2021-06-22 13:55:39" }
    developer { Faker::Company.name }
    system_requirement 
  end
end
