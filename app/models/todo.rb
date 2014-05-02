class Todo < ActiveRecord::Base

  belongs_to :list

  validates :body, length: { minimum: 3 }, presence: true
  validates :list, presence: true

  default_scope { order('created_at DESC') }

  def days_left(lifetime)
    (lifetime - ((Time.now - self.created_at) / 1.hour.seconds).round(1))
  end
end
