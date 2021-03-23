FactoryBot.define do
  factory :user do
    email {'aaa@example.com'}
    password {'password'}
    password_confirmation {'password'}
    created_at {Time.now}
    updated_at {Time.now}
  end
end
