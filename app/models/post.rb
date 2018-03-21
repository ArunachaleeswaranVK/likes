class Post < ActiveRecord::Base
    has_many :likes
    has_many :users, through: :likes
    
    include SimpleRecommender::Recommendable
    similar_by :users
end
