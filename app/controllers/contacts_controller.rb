class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts or /contacts.json
  def index
    @groups = current_user.groups
    @selected_group_id = params[:group_id]
    @search_term = params[:search]
    @contacts = current_user.contacts

    # Filter contacts by selected group
    if @selected_group_id.present?
      @contacts = @contacts.joins(:groups).where(groups: { id: @selected_group_id })
    end

    # Search contacts by name, email, or phone
    if @search_term.present?
      term = "%#{@search_term}%"
      @contacts = @contacts.where("contacts.name LIKE ? OR contacts.email LIKE ? OR contacts.phone LIKE ?", term, term, term)
    end
   
    
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
      group_ids = params.dig(:contact, :group_ids)&.reject(&:blank?) || []
      @contact.group_ids = group_ids
      redirect_to @contact, notice: "Contact was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    if @contact.update(contact_params)
      group_ids = params[:contact][:group_ids].reject(&:blank?)
      @contact.groups = current_user.groups.where(id: group_ids)
      redirect_to @contact, notice: 'Contact was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
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
