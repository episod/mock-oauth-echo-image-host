ActionController::Routing::Routes.draw do |map|
  map.echo 'api/upload', :controller => "api", :action => "upload"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
