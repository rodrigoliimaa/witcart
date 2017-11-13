FactoryBot.define do
  factory :product_learn_ror, class: Product do
    name "Learn RoR - Beginner"
    price "24.99"
  end

  factory :product_mastering_ror, class: Product do
    name "Mastering RoR - Level over 9000"
    price "9001.99"
  end
end
