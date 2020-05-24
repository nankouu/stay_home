class Post < ApplicationRecord
	belongs_to :genre,optional: true
	belongs_to :user
	has_many :comments,dependent: :destroy
	has_many :favorites, dependent: :destroy
	has_many :users, through: :favorites
	acts_as_taggable

	attachment :image

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end
end
