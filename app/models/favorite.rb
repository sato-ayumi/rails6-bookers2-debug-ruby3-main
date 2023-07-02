class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  # 一つの投稿に対して、１いいねしか付けれないのを防ぐための記述
  validates_uniqueness_of :book_id, scope: :user_id
end
