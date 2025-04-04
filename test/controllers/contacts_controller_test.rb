require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
    @contact = contacts(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get contacts_url
    assert_response :success
  end



  test "should create contact" do
    assert_difference("Contact.count") do
      post contacts_url, params: { contact: { email: @contact.email, name: @contact.name, phone: @contact.phone, group_ids: [groups(:one).id]  } }
    end

    assert_redirected_to contact_url(Contact.last)
  end

  test "should show contact" do
    get contact_url(@contact)
    assert_response :success
  end

  test "should get edit" do
    get edit_contact_url(@contact)
    assert_response :success
  end

  test "should destroy contact" do
    assert_difference("Contact.count", -1) do
      delete contact_url(@contact)
    end

    assert_redirected_to contacts_url
  end
end
