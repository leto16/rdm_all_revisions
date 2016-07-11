# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/repository/:repository_id/all_revisions', :to => 'all_revisions#show'