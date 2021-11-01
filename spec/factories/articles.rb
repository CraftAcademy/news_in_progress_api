FactoryBot.define do
  factory :article do
    title { 'MyTitle' }
    lede { 'MyLede' }
    body { 'MyBody' }
    category
    category_id { category.id }
    published { true }

    after(:build) do |article|
      article.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'placeholder.png')),
                           filename: 'placeholder.png', content_type: 'image/png')
    end
  end
end
