class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  scope :created_today, -> {where(created_at: Time.zone.now.all_day)}
  scope :created_yesterday, -> {where(created_at: 1.day.ago.all_day)}
  scope :created_2day_ago, -> {where(created_at: 2.day.ago.all_day)}
  scope :created_3day_ago, -> {where(created_at: 3.day.ago.all_day)}
  scope :created_4day_ago, -> {where(created_at: 4.day.ago.all_day)}
  scope :created_5day_ago, -> {where(created_at: 5.day.ago.all_day)}
  scope :created_6day_ago, -> {where(created_at: 6.day.ago.all_day)}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end
  
  def update_favorites_count
    update_column(:favorites_count, favorites.count)
  end
  
end
