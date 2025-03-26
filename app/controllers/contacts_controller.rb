class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts or /contacts.json
  def index
    # Get the contacts for the current user
    @contacts = current_user.contacts
    # Get the groups for the current user
    @groups = current_user.groups # This will set @groups to the user's groups
  end

  # GET /contacts/1 or /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts or /contacts.json
  def create
    @contact = current_user.contacts.build(contact_params)

    if @contact.save
      redirect_to @contact, notice: 'Contact was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: 'Contact was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      params.require(:contact).permit(:name, :phone, :email)
    end
end
