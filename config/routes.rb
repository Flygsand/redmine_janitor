ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'janitor' do |janitor_routes|
    janitor_routes.connect 'janitor', :conditions => { :method => :get }, :action => 'index'
    janitor_routes.connect 'janitor/clean', :conditions => { :method => :post }, :action => 'clean'
  end
end
