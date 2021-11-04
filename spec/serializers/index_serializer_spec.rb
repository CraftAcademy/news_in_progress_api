describe Articles::IndexSerializer, type: :serializer do
  let(:article_1) { create(:article) }
  let(:article_2) { create(:article) }
  let(:article_3) { create(:article) }

  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new([article_1, article_2, article_3],
                                                     each_serializer: described_class)
  end

  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting modal name' do
    expect(subject.keys).to match ['articles']
  end

  it 'is expected to contain relevant keys' do
    expected_keys = %w[id title lede updated_at published image authors_as_sentence top_story category authors]
    expect(subject['articles'].last.keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject['articles'].last).to match(
      {
        'id' => an_instance_of(Integer),
        'title' => an_instance_of(String),
        'lede' => an_instance_of(String),
        'updated_at' => an_instance_of(String),
        'published' => an_instance_of(TrueClass),
        'category' => an_instance_of(Hash),
        'category' => {
          'id' => an_instance_of(Integer),
          'name' => an_instance_of(String)
        },
        'authors' => an_instance_of(Array),
        'image' => an_instance_of(String),
        'authors_as_sentence' => an_instance_of(String),
        'top_story' => an_instance_of(FalseClass)
      }
    )
  end
end
