class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  has_many :posts,dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :posts, through: :favorites
  has_many :sns_credentials, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower

  attachment :image


	def self.without_sns_data(auth)
	    user = User.where(email: auth.info.email).first

	      if user.present?
	        sns = SnsCredential.create(
	          uid: auth.uid,
	          provider: auth.provider,
	          user_id: user.id
	        )
	      else
	        user = User.new(
	          name: auth.info.name,
	          email: auth.info.email,
	        )
	        sns = SnsCredential.new(
	          uid: auth.uid,
	          provider: auth.provider
	        )
	      end
	      return { user: user ,sns: sns}
	end

	def self.with_sns_data(auth, snscredential)
	    user = User.where(id: snscredential.user_id).first
	    unless user.present?
	      user = User.new(
	        nickname: auth.info.name,
	        email: auth.info.email,
	      )
	    end
	    return {user: user}
	end

	def self.find_oauth(auth)
	    uid = auth.uid
	    provider = auth.provider
	    snscredential = SnsCredential.where(uid: uid, provider: provider).first
	    if snscredential.present?
	      user = with_sns_data(auth, snscredential)[:user]
	      sns = snscredential
	    else
	      user = without_sns_data(auth)[:user]
	      sns = without_sns_data(auth)[:sns]
	    end
	    return { user: user ,sns: sns}
	end

	def already_favorited?(post)
		self.favorites.exists?(post_id: post.id)
	end

	def follow(user_id)
	    follower.create(followed_id: user_id)
	end

	def unfollow(user_id)
	follower.find_by(followed_id: user_id).destroy
	end

	def following?(user)
	following_user.include?(user)
	end
end