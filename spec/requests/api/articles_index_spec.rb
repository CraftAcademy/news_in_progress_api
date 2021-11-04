RSpec.describe 'GET /api/articles', type: :request do
  subject { response }

  describe 'when there are some article in the database' do
    let(:journalist) { create(:journalist, name: 'Bob Woodward') }
    let(:category) { create(:category, name: 'Tech') }
    let!(:article_1) { create(:article, category: category) }
    let!(:article_2) { create(:article, category: category) }
    let!(:article_3) { create(:article, authors: [journalist]) }

    describe 'searching for all articles' do
      before do
        get '/api/articles'
      end
      it { is_expected.to have_http_status 200 }

      it 'is expected to return a collection of articles' do
        expect(response_json['articles'].count).to eq 3
      end

      it 'is expected to include a category value' do
        expect(response_json['articles'].last['category']['name']).to eq 'MyCategory'
      end

      it 'is expected to return an article with the published status true' do
        expect(response_json['articles'].last['published']).to eq true
      end

      it 'is expected to return the author of the article' do
        expect(response_json['articles'].last['authors'].last['name']).to eq 'Bob Woodward'
      end

      it 'is expected to return the author of the article as a sentence' do
        expect(response_json['articles'].last['authors_as_sentence']).to eq 'Bob Woodward'
      end

      it 'is expected to return an boolean for a top story' do
        expect(response_json['articles'].last['top_story']).to eq false
      end

      it 'is expected to return an image with the article' do
        expect(response_json['articles'].last).to include 'image'
      end
    end

    describe 'search for articles by categories' do
      before do
        get '/api/articles/',
            params: { category: 'Tech' }
      end
      it {
        is_expected.to have_http_status 200
      }

      it 'is expected to return a collection of articles' do
        expect(response_json['articles'].count).to eq 2
      end
    end

    describe 'when the category params dont exist' do
      before do
        get '/api/articles/',
            params: { category: 'Sports' }
      end

      it 'is expected to return a collection of articles' do
        expect(response_json['articles'].count).to eq 3
      end
    end
  end

  describe 'when there are no articles in the database' do
    before do
      get '/api/articles'
    end

    it { is_expected.to have_http_status 404 }

    it 'is expected to respond with a negative message when no articles are found' do
      expect(response_json['message']).to eq 'There are no articles in the database'
    end
  end

  describe 'when the article is not published' do
    let!(:article_4) { create(:article, published: false) }
    let!(:article_5) { create(:article) }
    before do
      get '/api/articles/'
    end

    it { is_expected.to have_http_status 200 }

    it 'is expected to NOT return an unpublished article' do
      expect(response_json['articles'].count).to eq 1
    end
  end
end
