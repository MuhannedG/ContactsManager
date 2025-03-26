class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[ show edit update destroy ]

  # GET /groups
  def index
    @groups = current_user.groups
  end

  # GET /groups/1
  def show
    @contacts = @group.contacts
  end

  # GET /groups/new
  def new
    @group = current_user.groups.build
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = current_user.groups.build(group_params)
    if @group.save
<<<<<<< HEAD
      redirect_to group_url(@group), notice: "Group was successfully created."
=======
      redirect_to @group, notice: "Group was successfully created."
>>>>>>> 12af641c8ec44d3968c9ae7c82c1eeffd146838a
    else
      render :new, status: :unprocessable_entity
    end
  end
<<<<<<< HEAD
  
  
=======
>>>>>>> 12af641c8ec44d3968c9ae7c82c1eeffd146838a

  # PATCH/PUT /groups/1
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy!
    respond_to do |format|
      format.html { redirect_to groups_path, status: :see_other, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = current_user.groups.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to groups_path, alert: "Group not found."
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :description)
    end
end
