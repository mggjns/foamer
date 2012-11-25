module ApplicationHelper

	def location_for(event)
        if event[:location]
            "Where: #{event[:location]}"
        else
            "Where: <em>No location yet!</em>".html_safe
        end
	end

	def description_for(event)
        if event[:description]
            "#{event[:description]}"
        end
	end

end
