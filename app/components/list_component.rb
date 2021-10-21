# frozen_string_literal: true

class ListComponent < ViewComponent::Base
  def initialize(events:)
    @events = []
    events.each do |event|
      if event.event_details['recurrence_description'].start_with?('Every')
        if event.event_details['resources'].nil?
        else
          if event.event_details['resources']['resource'].class == Hash
            if event.event_details['resources']['resource']['name'] == 'Reoccurring Events'
              @events.append(event)
            else
            end
          else
            event.event_details['resources']['resource'].each do |e|
              if e['name'] == 'Reoccurring Events'
                @events.append(event)
              end
            end
          end
        end
        elsif DateTime.parse(event.event_details['end_date']).to_date >= Date.today
        @events.append(event)
      end
    end
  end
end
