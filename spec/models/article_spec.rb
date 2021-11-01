RSpec.describe Article, type: :model do
  describe 'DB table' do
    it { is_expected.to have_db_column :title }
    it { is_expected.to have_db_column :lede }
    it { is_expected.to have_db_column :body }
    it { is_expected.to have_db_column :category_id }
    it { is_expected.to have_db_column :published }
    it { is_expected.to have_db_column :top_story }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :lede }
    it { is_expected.to validate_presence_of :body }
  end

  describe 'Associations' do
    it { is_expected.to belong_to :category }
    it {
      is_expected.to have_and_belong_to_many(:authors)
        .class_name('User')
    }
  end

  describe 'Factory' do
    it 'is expected to have valid Factory' do
      expect(create(:article)).to be_valid
    end
  end

  describe 'Attachments' do
    it 'is expected to be able to attach an image' do
      subject.image.attach(io: File.open(fixture_path + '/images/placeholder.png'), filename: 'attachment.png',
                           content_type: 'image/png')
      expect(subject.image).to be_attached
    end
  end
end
