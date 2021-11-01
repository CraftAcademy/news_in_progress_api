class Articles::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :lede, :updated_at, :published, :authors_as_sentence

  belongs_to :category, serializer: Categories::IndexSerializer
  has_many :authors, serializer: Users::AuthorsIndexSerializer

  def authors_as_sentence
    object.authors.pluck(:name).to_sentence
  end
end
