FactoryBot.define do
  factory :product do
    sequence(:code) { |n| "PROD#{n}" }
    sequence(:name) { |n| "Product #{n}" }
    price { 10.00 }

    trait :green_tea do
      code { "GR1" }
      name { "Green Tea" }
      price { 3.11 }
    end

    trait :strawberries do
      code { "SR1" }
      name { "Strawberries" }
      price { 5.00 }
    end

    trait :coffee do
      code { "CF1" }
      name { "Coffee" }
      price { 11.23 }
    end
  end
end 