RSpec.describe 'POST /api/articles', type: :request do
  subject { response }
  let(:user) { create(:journalist) }
  let(:credentials) { user.create_new_auth_token }
  let(:category) { create(:category, name: 'Tech') }
    describe 'successful, when the article is created' do
    before do
      category.save
      post '/api/articles',
           params: { article: { title: 'Amazing title',
                                lede: 'Amazing lede...',
                                body: 'Amazing body',
                                author_ids: [],
                                category: 'Tech',
                                image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAGSCAMAAAAM4OJtAAAABGdBTUEAALGPC',
                                published: true } },
           headers: credentials
    end

    it { is_expected.to have_http_status 201 }

    it 'is expected to attach an image to the new article' do
      article = Article.last
      expect(article.image).to be_attached
    end

    it 'is expected to return a response message' do
      expect(response_json['message']).to eq(
        'You have successfully added Amazing title to the site'
      )
    end
  end

  describe 'unsuccessful, when the article is not created' do
    describe 'because the title is missing' do
      before do
        category.save
        post '/api/articles',
             params: { article: { lede: "I'm missing a title",
                                  body: "I'm missing a title",
                                  author_ids: [],
                                  category: 'Tech',
                                  image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAGSCAMAAAAM4OJtAAAABGdBTUEAALGPC',
                                  published: false } },
             headers: credentials
      end

      it { is_expected.to have_http_status 422 }

      it 'is expected to to ask for a title when the title is missing' do
        expect(response_json['errors']).to eq(
          "Title can't be blank"
        )
      end
    end

    describe 'because the lede is missing' do
      before do
        category.save
        post '/api/articles',
             params: { article: { title: 'I forgot the lede',
                                  body: 'I forgot the lede',
                                  author_ids: [],
                                  category: 'Tech',
                                  image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAGSCAMAAAAM4OJtAAAABGdBTUEAALGPC',
                                  published: false } },
             headers: credentials
      end

      it { is_expected.to have_http_status 422 }

      it 'is expected to ask for a lede when the lede is missing' do
        expect(response_json['errors']).to eq(
          "Lede can't be blank"
        )
      end
    end

    describe 'because the body is missing' do
      before do
        category.save
        post '/api/articles',
             params: { article: { title: 'I forgot the body',
                                  lede: 'I forgot the body',
                                  author_ids: [],
                                  category: 'Tech',
                                  image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAGSCAMAAAAM4OJtAAAABGdBTUEAALGPC',
                                  published: false } },
             headers: credentials
      end

      it { is_expected.to have_http_status 422 }

      it 'is expected to ask for the body when the body is missing' do
        expect(response_json['errors']).to eq("Body can't be blank")
      end
    end

    describe 'because the category is missing' do
      before do
        category.save
        post '/api/articles',
             params: { article: { title: 'I forgot the category',
                                  lede: 'I forgot the category',
                                  body: 'I forgot the category',
                                  image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAeAAAAGSCAMAAAAM4OJtAAAABGdBTUEAALGPC',
                                  author_ids: [],
                                  published: false } },
             headers: credentials
      end

      it { is_expected.to have_http_status 422 }

      it 'is expected to return an error when the category is missing' do
        expect(response_json['errors']).to eq('Category must exist')
      end
    end
  end

  describe 'Unsuccessful, when an article without image passed in' do
    before do
      category.save
      post '/api/articles',
           params: { article: { title: 'Amazing title',
                                lede: 'Amazing lede...',
                                body: 'Amazing body',
                                author_ids: [],
                                category: 'Tech',
                                published: true } },
           headers: credentials
    end

    it 'is expected to return a successful response message when image is not passed in' do
      expect(response_json['errors']).to eq "Image can't be blank"
    end
  end

  describe 'unsuccessful, when the API is unable to process the image' do
    before do
      category.save
      post '/api/articles',
           params: { article: { title: 'Amazing title',
                                lede: 'Amazing lede...',
                                body: 'Amazing body',
                                author_ids: [],
                                category: 'Tech',
                                image: 'useless nonsense',
                                published: true } },
           headers: credentials
    end

    it 'is expected to return an error message when an image that cannot be processed is passed in' do
      expect(response_json['errors']).to eq "Image can't be blank"
    end
  end
end
