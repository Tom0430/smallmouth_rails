FactoryBot.define do
    factory :user do
        name { "太郎" }
        email { "rspec@test.com" }
        password { "rspecpass" }
    end
end