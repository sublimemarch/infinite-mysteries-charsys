module ApplicationHelper
	CHARACTER_STATUS = ['In Progress', 'Submitted', 'Approved', 'Active', 'Deceased', 'Inactive']

	def get_status(status)
		return CHARACTER_STATUS[status]
	end
end
