class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :recent_posts, ->{order created_at: :desc}
  validates :user_id, presence: true
  validates :content, presence: true,
   length: {maximum: Settings.max_content_micropost}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("microposts.validate_img")},
                    size: {less_than: Settings.less_than_size.megabytes,
                           message: I18n.t("microposts.less_than")}

  def display_image
    image.variant resize_to_limit: [Settings.limit_img, Settings.limit_img]
  end
end
