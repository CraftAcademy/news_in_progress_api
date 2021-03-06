class Articles::ShowSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :lede, :body, :updated_at, :image, :authors_as_sentence

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
