class Articles::IndexSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :lede, :updated_at, :published, :image, :authors_as_sentence, :top_story

  belongs_to :category, serializer: Categories::IndexSerializer
  has_many :authors, serializer: Users::AuthorsIndexSerializer

  def image
    # if Rails.env.test?
      rails_blob_path(object.image, only_path: true)
    # else
    #   object.image.service_url(expires_in: 30.minutes)
    # end
  end
end
