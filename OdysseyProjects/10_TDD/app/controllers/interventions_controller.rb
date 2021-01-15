class InterventionsController < ApplicationController
  before_action :set_intervention, only: [:show, :edit, :update, :destroy]
  before_action :is_employee? #method for check is the current user is a employee


  # GET /interventions
  # GET /interventions.json
  def index
    @interventions = Intervention.all
  end

  # GET /interventions/1
  # GET /interventions/1.json
  def show
  end

  # GET /interventions/new
  def new
    @intervention = Intervention.new
  end
  
  # GET /interventions/1/edit
  def edit
  end
  
  # POST /interventions
  # POST /interventions.json
  def create
    @intervention = Intervention.new(intervention_params)

    # Get format name of employee connected
    employee = current_user.employee.full_name

    # Give the id of the employee connected
    @intervention.author_id = current_user.employee.id

    # Data get for zendesk ticket
    battery_id = @intervention.battery_id
    column_id = @intervention.column_id
    elevator_id = @intervention.elevator_id

    # Condition for null ids not required
    if @intervention.elevator_id
      @intervention.battery_id = nil
      @intervention.column_id = nil
    elsif @intervention.column_id
      @intervention.battery_id = nil
    end

    pp @intervention

    respond_to do |format|
      if @intervention.save
        format.html { redirect_to '/interventions/new', notice: 'Intervention was successfully created.' }
        format.json { render :show, status: :created, location: @intervention }

        # Call method for create a zendesk ticket
        # helpers.ticket_intervention(@intervention, employee, battery_id, column_id, elevator_id)
      else
        format.html { render :new }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interventions/1
  # PATCH/PUT /interventions/1.json
  def update
    respond_to do |format|
      if @intervention.update(intervention_params)
        format.html { redirect_to @intervention, notice: 'Intervention was successfully updated.' }
        format.json { render :show, status: :ok, location: @intervention }
      else
        format.html { render :edit }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1
  # DELETE /interventions/1.json
  def destroy
    @intervention.destroy
    respond_to do |format|
      format.html { redirect_to interventions_url, notice: 'Intervention was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_intervention
    @intervention = Intervention.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def intervention_params
    params.require(:intervention).permit(
        :customer_id,
        :building_id,
        :battery_id,
        :column_id,
        :elevator_id,
        :employee_id,
        :start_date_intervention,
        :end_date_intervention,
        :result,
        :report,
        :status,
        :author_id)
  end
end
