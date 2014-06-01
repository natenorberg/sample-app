module ApplicationHelper

	# Renders the title for each page
	def full_title(page_title)
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end 
	end

	def bootstrap_class_for(flash_type)
		case flash_type
		when 'success'
			"alert-success"
		when 'error'
			"alert-danger"
		else
			flash_type.to_s
		end
	end
	
end
