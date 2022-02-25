FactoryBot.define do
  factory :award do
    title { "Award title" }

    trait :with_image do
      image { Rack::Test::UploadedFile.new("#{Rails.root}/storage/download.png") }
    end
    question
  end
end
