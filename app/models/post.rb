class Post < ApplicationRecord
	belongs_to :user
	has_many :comments,dependent: :destroy
	has_many :favorites, dependent: :destroy
	acts_as_taggable

	attachment :image

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
