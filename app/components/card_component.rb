# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(events:)
    e = events
    @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                   .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
  end

end
