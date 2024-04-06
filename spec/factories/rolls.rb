FactoryBot.define do
  factory :roll do
    association :frame
    pins_knocked_down { 5 }
  end
end
