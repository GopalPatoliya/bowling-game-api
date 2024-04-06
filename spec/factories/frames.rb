FactoryBot.define do
  factory :frame do
    association :game
    frame_number { 1 }
  end
end
