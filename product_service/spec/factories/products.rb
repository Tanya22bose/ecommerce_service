FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { "#{Faker::Commerce.department}\nBrand: #{Faker::Commerce.brand}\nMaterial: #{Faker::Commerce.material}" }
    price { Faker::Commerce.price }
    # images { Faker::LoremFlickr.image }
  end
end