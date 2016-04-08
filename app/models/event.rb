class Event < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true, length: { maximum: 255 }
  validates :subject, presence: true, length: { maximum: 255 }
  validates :description, presence: true
  validates :date, presence: true
  COST_REGEX = /\A^\d+\.?\d+$\z/i
  validates :cost, presence: true, format: { with: COST_REGEX }, length: { maximum: 5 }
  validates :place, presence: true, length: { maximum: 255 }
  validate :cost_size

  private
  def cost_size
    if cost > 20
      errors.add(:cost, " is too high for one person")
    end
  end
end
