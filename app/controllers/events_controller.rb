class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy,:accept_request, :reject_request,:join]
  before_action :authenticate_user!, only: [:new,:edit, :update,:destroy,:join]
  before_action :event_owner!, only: [:update, :edit,:destroy]
  respond_to :html, :json
  # GET /events
  # GET /events.json
  def index
    if params[:tag]
      @events = Event.tagged_with(params[:tag])
    else
      @events = Event.all
    end
  end

  def my_events
    @my_events = current_user.organized_events
  end

 def join
    @attandance = Attendance.join_event(current_user.id, params[:event_id], 'request_send')
    'Request Send' if @attandance.save   
    # redirect_to Event.find(params[:event_id])
       respond_to do |format| 
        format.html { redirect_to @event, notice: 'Resuest Send' }
        format.json { render :show, status: :created, location: @event }
    end
  end

  def reject_request
    @attendance =Attendance.find(params[:attendance_id]) rescue nil
    @attendance.reject!
    'Attendance accept' if @attendance.save
    respond_to do |format| 
        format.html { redirect_to @event, notice: 'Attendance reject' }
        format.json { render :show, status: :created, location: @event }
    end
  end

    def accept_request
    @attendance =Attendance.find(params[:attendance_id]) rescue nil
    @attendance.accept!
    'Attendance accept' if @attendance.save
    respond_to do |format|
        format.html { redirect_to @event, notice: 'Attendance accept' }
        format.json { render :show, status: :created, location: @event }
    end
  end
  # GET /events/1
  # GET /events/1.json
  def show
    @attendances = Event.show_accepted_attendance(@event.id)
    @pending_requests = Event.pending_requests(@event.id)
    @organizer = Event.event_owner(@event.organizer)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.organized_events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      params[:id] = params[:event_id] unless params[:id]
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start_date, :end_date, :location, :agenda, :address, :organizer_id,
          :all_tags,:attendance_id)
    end

    def event_owner!
      authenticate_user!
      if @event.organizer_id != current_user.id
        redirect_to @event
        flash[:notice] = "You don't have enough permissions to do this"
      end
    end
end
