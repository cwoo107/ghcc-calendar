# frozen_string_literal: true

class ListComponent < ViewComponent::Base
  def initialize(events:)
    @events = events
  end

end
