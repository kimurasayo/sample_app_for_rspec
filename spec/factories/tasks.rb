FactoryBot.define do
  factory :task do
    title {'title'}
    content {'content'}
    status {0}
    deadline {'tomorrow'}
    created_at {Time.now}
    updated_at {Time.now}
    user
  end
end
