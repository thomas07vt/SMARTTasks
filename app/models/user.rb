class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :username, :uniqueness => { :case_sensitive => false }, length: { minimum: 3}, presence: true

  has_many :lists, dependent: :destroy

end
