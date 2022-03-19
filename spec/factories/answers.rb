FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after(:create) do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end
  end
end
