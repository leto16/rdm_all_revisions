require 'redmine'

Redmine::Plugin.register :all_revisions do
  name 'All Revisions plugin Redmine'
  author 'Aleksandr Sipovich'
  description 'This is a plugin for Redmine which form united revision for the issue'
  version '0.0.1'
  url 'https://github.com/all_revisions'
  author_url 'https://github.com/leto16'
end

require 'all_revisions/issue_hook'