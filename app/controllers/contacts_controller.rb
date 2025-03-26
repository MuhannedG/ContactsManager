class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: %i[ show edit update destroy ]

  def index
    @groups = current_user.groups
    @selected_group_id = params[:group_id]
    @search_term = params[:search]

    @contacts = current_user.contacts

    if @selected_group_id.present?
      @contacts = @contacts.joins(:groups).where(groups: { id: @selected_group_id })
    end

    if @search_term.present?
      @contacts = @contacts.where("contacts.name ILIKE ? OR contacts.email ILIKE ?", "%#{@search_term}%", "%#{@search_term}%")
    end
  end

  def show
  end

  def new
    @contact = current_user.contacts.build
  end

  def edit
  end

  def create
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      redirect_to contacts_path, notice: "Contact was successfully created."
    else
      render :new
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: "Contact was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, status: :see_other, notice: "Contact was successfully destroyed."
  end

  private

    def set_contact
      @contact = current_user.contacts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to contacts_path, alert: "Contact not found."
    end

    def contact_params
      params.require(:contact).permit(:name, :phone, :email, group_ids: [])
    end
end
