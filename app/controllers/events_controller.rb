class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :allow_iframe_requests
  skip_before_action :verify_authenticity_token, only: %i[ search list]
  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end
  # GET /events or /events.json
  def index
    #if params[:public] == 'false'
    #  @events = Event.where("event_details ->> 'image' != ''")
    #                 .order(Arel.sql "(event_details ->> 'start_datetime')::date  ASC")
    #elsif params[:past] == 'true'
    #@events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
    #               .where("(event_details ->> 'end_date')::date <= :today", today: Date.today)
    #               .order(Arel.sql "(event_details ->> 'start_datetime')::date  ASC")
    #else
    #  @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
    #                 .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
    #                 .or(Event.where("event_details ->> 'recurrence_description' LIKE 'Every%'"))
    #                 .order(Arel.sql "(event_details ->> 'start_datetime')::date  DESC")
    #end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  def search
    if params[:query].present?
      @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                     .where("event_details::text ilike ?", "%#{params[:query]}%")
                     .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
                     .or(Event.where("event_details ->> 'recurrence_description' LIKE 'Every%'"))
                     .where("event_details::text ilike ?", "%#{params[:query]}%")
                     .order(Arel.sql "(event_details ->> 'start_datetime')::date  DESC")
    else
      @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                     .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
                     .or(Event.where("event_details ->> 'recurrence_description' LIKE 'Every%'"))
                     .order(Arel.sql "(event_details ->> 'start_datetime')::date  DESC")
    end

    render turbo_stream: turbo_stream.replace(
      'list',
      template: 'events/list',
      locals: {
        events: @events
      }
    )
  end

  def list
    @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                   .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
                   .or(Event.where("event_details ->> 'recurrence_description' LIKE 'Every%'"))
                   .order(Arel.sql "(event_details ->> 'start_datetime')::date  DESC")
    render layout: false
  end

  def slides
    @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                   .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
                   .or(Event.where("event_details ->> 'recurrence_description' LIKE 'Every%'"))
                   .order(Arel.sql "(event_details ->> 'start_datetime')::date  DESC")
    render layout: false
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:event_details)
    end
end
