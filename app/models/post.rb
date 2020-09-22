class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum:140 }
  validates :image,   presence:true,   
                      content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "有効な画像形式である必要があります" },
                      size:         { less_than: 5.megabytes,
                                      message: "5MB未満である必要があります" }
  def display_image
    image.variant(resize_to_limit:[500,600])
  end

  def like_by?(user)
    likes.where(user_id: user_id).exist?
  end
end
