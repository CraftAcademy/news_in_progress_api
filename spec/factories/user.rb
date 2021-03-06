FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password' }
    name { Faker::Name.unique.name }
    factory :registered_user do
    role { :registered_user }  
    end
    factory  :editor do
      role { :editor }
    end
    factory :subscriber do
      role { :subscriber }
    end
    factory :journalist do
      role { :journalist }
    end
  end
end
