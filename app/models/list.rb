class List < ActiveRecord::Base
  belongs_to :user

  has_many :todos, dependent: :destroy

  validates :title, length: { minimum: 3 }, presence: true
  validates :user, presence: true

  def self.valid_permission?(permission)
    permissions = ["open", "viewable", "private"]
    permissions.include?(permission.to_s)
  end
end
