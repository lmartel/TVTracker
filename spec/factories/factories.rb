FactoryGirl.define do
  factory :show do
    sequence(:name) { |n| "foo#{n}" }

  end
  factory :wiki_page do
    sequence(:name) { |n| "List of Foo#{n} episodes"}
  end
  
  factory :wiki do
    name "Wikipedia"
  end
end