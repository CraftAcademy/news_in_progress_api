describe Articles::ShowSerializer, type: :serializer do
  let(:article) { create(:article) }
  let(:serialization) do
    ActiveModelSerializers::SerializableResource.new(
      article,
      serializer: described_class
    )
  end

  subject { JSON.parse(serialization.to_json) }

  it 'is expected to wrap content in key reflecting modal name' do
    expect(subject.keys).to match ['article']
  end

  it 'is expected to contain relevant keys' do
    expected_keys = %w[id title lede body updated_at image category authors]
    expect(subject['article'].keys).to match expected_keys
  end

  it 'is expected to have a specific structure' do
    expect(subject).to match(
      'article' => {
        'id' => an_instance_of(Integer),
        'title' => an_instance_of(String),
        'lede' => an_instance_of(String),
        'body' => an_instance_of(String),
        'updated_at' => an_instance_of(String),
        'category' => an_instance_of(Hash),
        'category' => {
          'id' => an_instance_of(Integer),
          'name' => an_instance_of(String)
        },
        'authors' => an_instance_of(Array),
        'image' => an_instance_of(String)
      }
    )
  end
end
