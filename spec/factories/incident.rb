FactoryBot.define do
  factory :incident do
    title { "My incident" }
    description { "Some description" }
    severity { "sev0" }
    creator { "John Doe" }
    status { "open" }
    channel_id { "C1234567890" }
  end
end
