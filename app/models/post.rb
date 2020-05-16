class Post < ApplicationRecord
	belongs_to :user
	has_many :comments,dependent: :destroy
	has_many :favorites, dependent: :destroy
	has_many :users, through: :favorites

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def self.search(search)
		if search
			Post.where(['title LIKE ?',"%#{search}%"])
		else
			Post.all
		end
	end
end
