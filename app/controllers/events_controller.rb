class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :allow_iframe_requests
  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end
  # GET /events or /events.json
  def index
    if params[:public] == 'false'
      @events = Event
                     .order(Arel.sql "(event_details ->> 'start_datetime')::date  ASC")
    elsif params[:past] == 'true'
    @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                   .where("(event_details ->> 'end_date')::date <= :today", today: Date.today)
                   .order(Arel.sql "(event_details ->> 'start_datetime')::date  ASC")
    else
      @events = Event.where("event_details ->> 'public_calendar_listed' = 'true'" )
                     .where("(event_details ->> 'end_date')::date >= :today", today: Date.today)
                     .order(Arel.sql "(event_details ->> 'start_datetime')::date  ASC")
    end
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
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
