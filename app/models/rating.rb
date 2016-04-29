class Rating < ActiveRecord::Base
  belongs_to :user, class_name: 'User'

  validates :score, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
  validates :tutor_id, presence: true
  validate :rating_score

  private
  def rating_score
    if score > 10 || score < 0
      errors.add(:score, "must be between 0 and 10.")
    end
  end
end
