class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   has_many :organized_events, class_name: "Event", foreign_key: "organizer_id", dependent: :destroy
   has_many :attandances
   has_many :events, through: :attandances
end
