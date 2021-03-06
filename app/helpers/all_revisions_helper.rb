module AllRevisionsHelper

  def render_changesets_changes
	  changes = []
	  @changesets.each do |changeset|
      if changeset.present?
  	    changes += changeset.filechanges.limit(1000).reorder('path').collect do |change|
  	      case change.action
  	      when 'A'
  	        # Detects moved/copied files
  	        if !change.from_path.blank?
  	          change.action =
  	             changeset.filechanges.detect {|c| c.action == 'D' && c.path == change.from_path} ? 'R' : 'C'
  	        end
  	        change
  	      when 'D'
  	        changeset.filechanges.detect {|c| c.from_path == change.path} ? nil : change
  	      else
  	        change
  	      end
  	    end
      end
	  end

	  mod_file = ("A".."Z").to_a.reverse + ("a".."z").to_a.reverse
    iterator = 0
    list_of_files = []

    tree = { }
    changes.reverse.each do |change|
      p = tree
      dirs = change.path.to_s.split('/').select {|d| !d.blank?}
      path = ''
      dirs.each do |dir|
        iterator = 0 if iterator == mod_file.length

      	if dir == dirs.last
          if change.action == 'M'
            if !list_of_files.index(dir)
              list_of_files << dir
        	    path += '/' + dir + mod_file[iterator]
              iterator += 1
            else
              path = ''
            end
          else
            path += '/' + dir + mod_file[iterator]
            iterator += 1
          end
        else
        	path += '/' + dir
        end
        p[:s] ||= {}
        p = p[:s]
        p[path] ||= {}
        p = p[path]
      end 
      p[:c] = change
    end
    render_changes_tree(tree[:s])
  end

  def render_changes_tree(tree)
    return '' if tree.nil?
    output = ''
    output << '<ul>'
    tree.keys.sort.each do |file|
      style = 'change'
      text = tree[file][:c] ? File.basename(h(file.slice(0, file.length - 1))) : File.basename(h(file))
      if s = tree[file][:s]
        style << ' folder'
        path_param = to_path_param(@repository.relative_path(file))
        text = link_to(h(text), :controller => 'repositories',
                             :action => 'show',
                             :id => @project,
                             :repository_id => @repository.identifier_param,
                             :path => path_param)
        output << "<li class='#{style}'>#{text}"
        output << render_changes_tree(s)
        output << "</li>"
      elsif c = tree[file][:c]
        style << " change-#{c.action}"
        path_param = to_path_param(@repository.relative_path(c.path))
        text = link_to(h(text), :controller => 'repositories',
                             :action => 'entry',
                             :id => @project,
                             :repository_id => @repository.identifier_param,
                             :path => path_param,
                             :rev => c.changeset.identifier) unless c.action == 'D'
        text << " - #{h(c.revision)}" unless c.revision.blank?
        
        text << ' '.html_safe + content_tag('span', h(c.from_path), :class => 'copied-from') unless c.from_path.blank?
        output << "<li class='#{style}'>#{text}</li>"
      end
    end
    output << '</ul>'
    output.html_safe
  end
end
