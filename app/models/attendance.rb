class Attendance < ActiveRecord::Base
	belongs_to :event
	belongs_to :user

	scope :accepted, -> {where(state:'accepted')}
	scope :pended, ->{where(state:'request_send')}
	include Workflow
	workflow_column :state

	workflow do
		state :request_send do
			event :accept, transitions_to: :accepted
			event :reject, transitions_to: :rejected
		end
		state :accepted
		state :rejected
	end

	def self.join_event(user_id, event_id,state)
		self.where(user_id: user_id, event_id:event_id).first_or_create(user_id: user_id, event_id: event_id, state: state)		
	end
end
