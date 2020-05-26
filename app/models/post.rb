class Post < ApplicationRecord
	belongs_to :genre,optional: true
	belongs_to :user
	has_many :comments,dependent: :destroy
	has_many :favorites, dependent: :destroy
	has_many :users, through: :favorites

	attachment :image
	acts_as_taggable

	validates :title,presence: true
	validates :image,presence: true

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def self.search(search)
      return Post.all unless search
      Post.where(['title LIKE ?', "%#{search}%"])
	end
end
