describe 'GET api/articles/:id', type: :request do
  subject { response }
  let(:user) { create(:user) }
  let(:journalist) { create(:journalist) }
  let(:credentials) { user.create_new_auth_token }

  describe 'successful, when the requested article exists in the database' do
    let!(:article) { create(:article, authors: [journalist]) }

    before do
      get "/api/articles/#{article.id}",
          headers: credentials
    end

    it { is_expected.to have_http_status 200 }

    it 'is expected to return an article with the title included' do
      expect(response_json['article']['title']).to eq 'MyTitle'
    end

    it 'is expected to return an article with the lede inculded' do
      expect(response_json['article']['lede']).to eq 'MyLede'
    end

    it 'is expected to return an article with the body included' do
      expect(response_json['article']['body']).to eq 'MyBody'
    end

    it 'is expected to return the author of the article' do
      expect(response_json['article']['authors'].last['name']).to eq journalist.name
    end

    it 'is expected to return an image with the article' do
      expect(response_json['article']).to include 'image'
    end
    
  end

  describe 'unsuccessful, when the requested article does not exist in the database' do
    before do
      get '/api/articles/999',
      headers: credentials
    end

    it { is_expected.to have_http_status 422 }

    it 'is expected to return an error message' do
      expect(response_json['errors']).to eq 'Your request could not be processed.'
    end
  end
end
