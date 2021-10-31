class Articles::IndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :lede, :updated_at, :published, :top_story

  belongs_to :category, serializer: Categories::IndexSerializer
  has_many :authors, serializer: Users::AuthorsIndexSerializer
end
