require File.dirname(__FILE__) + '/../test_helper'
require 'janitor_controller'

# Re-raise errors caught by the controller.
class JanitorController; def rescue_action(e) raise e end; end

class JanitorControllerTest < ActionController::TestCase

  fixtures :users, :wiki_contents, :wiki_content_versions
  
  def setup
    @controller = JanitorController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_routing
    assert_routing({:method => :get, :path => '/janitor'}, :controller => 'janitor', :action => 'index')
    assert_routing({:method => :post, :path => '/janitor/clean'}, :controller => 'janitor', :action => 'clean')
  end

  def test_admin_menu_entry_added
    @controller = AdminController.new
    get :index
    assert_response :success
    assert_tag :a, :attributes => { :href => '/janitor' },
                   :content => 'Janitor'
  end
  
  def test_index_as_admin
    get :index
    assert_response :success
    assert_template :index
  end

  def test_index_as_nonadmin
    @request.session[:user_id] = 2 # nonadmin
    get :index
    assert_response :forbidden
  end

  def test_clean_as_admin
    post :clean
    assert_response :redirect
  end

  def test_clean_as_nonadmin
    @request.session[:user_id] = 2 # nonadmin
    post :clean
    assert_response :forbidden
  end

  def test_delete_wiki_history
    post :clean, :delete_wiki_history => 1
    assert_response :redirect
    assert_redirected_to '/janitor'

    contents = WikiContent.find(:all)
    assert contents.all? { |c| c.versions.size <= 1 }
    assert contents.all? { |c| c.versions.earliest == c.versions.latest && (c.versions.earliest.nil? || c.versions.earliest.version == c.version) }
  end
end
