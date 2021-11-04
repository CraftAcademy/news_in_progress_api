class Article < ApplicationRecord
  validates_presence_of :title, :lede, :body
  belongs_to :category
  has_one_attached :image
  has_and_belongs_to_many :authors, class_name: 'User', join_table: 'articles_authors',
                                    association_foreign_key: 'author_id'
  validates :image, attached: true,
                    content_type: ['image/png', 'image/jpg', 'image/jpeg']

  def self.get_published_articles(category_name)
    articles_published = Article.where(published: true)
    if Category.pluck(:name).include? category_name
      articles_published.where(category_name: category_name)
    else
      articles_published
    end
  end

  def self.attach_image(article, params)
    image_params = params[:article][:image]
    image = decode_base64_string(image_params)
    if image
      decoded_data = Base64.decode64(image[:data])
      io = StringIO.new
      io << decoded_data
      io.rewind
      article.image.attach(io: io, filename: "#{article.title}.#{image[:extension]}", content_type: image[:type])

    end
  end

  def self.decode_base64_string(image_params)
    if image_params =~ /^data:(.*?);(.*?),(.*)$/
      object = {}
      object[:type] = Regexp.last_match(1)
      object[:encoder] = Regexp.last_match(2)
      object[:extension] = Regexp.last_match(1).split('/')[1]
      object[:data] = Regexp.last_match(3)
      object
    end
  end

  def authors_as_sentence
    authors.pluck(:name).to_sentence
  end
end
