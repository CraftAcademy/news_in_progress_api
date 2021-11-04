RSpec.describe 'POST /api/articles', type: :request do
  subject { response }
  let(:category) { create(:category) }
  let(:credentials) { user.create_new_auth_token }

  before do
    post '/api/articles',
         params: { article: { title: 'Amazing title',
                              lede: 'Amazing lede...',
                              body: 'Amazing body',
                              author_ids: [],
                              category: category,
                              image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAGSCAMAAAAM4OJtAAAABGdBTUEAALGPC',
                              published: true } },
         headers: credentials
  end

  describe 'unsuccessful, for registered users' do
    let(:user) { create(:registered_user) }

    it { is_expected.to have_http_status 401 }

    it 'is expected that they cannot create articles' do
      expect(response_json['errors']).to eq('You are not authorized to perform this action')
    end
  end

  describe 'unsuccessful, for subscribers' do
    let(:user) { create(:subscriber) }

    it { is_expected.to have_http_status 401 }

    it 'is expected that they cannot create articles' do
      expect(response_json['errors']).to eq('You are not authorized to perform this action')
    end
  end

  describe 'successful,for journalists' do
    let(:user) { create(:journalist) }

    it { is_expected.to have_http_status 201 }

    it 'is expected that they can create articles' do
      expect(response_json['message']).to eq('You have successfully added Amazing title to the site')
    end
  end

  describe 'successful, for editors' do
    let(:user) { create(:editor) }

    it { is_expected.to have_http_status 201 }

    it 'is expected that they can create articles' do
      expect(response_json['message']).to eq('You have successfully added Amazing title to the site')
    end
  end
end
