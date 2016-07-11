module AllRevisions
  class Hooks < Redmine::Hook::ViewListener    
      render_on(:view_issues_show_details_bottom, :partial => 'include/show_link_to_all_revision', :layout => false)
  end
end