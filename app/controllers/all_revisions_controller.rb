class AllRevisionsController < ApplicationController
  unloadable

  before_filter :find_project_repository, :show
  before_filter :find_changeset, :show
  
  before_filter :authorize
  accept_rss_auth :revisions

  def show
  	respond_to do |format|
      format.html
      format.js {render :layout => false}
  	end
  end

  def find_project_repository
    @project = Project.find(params[:id])
    @repository = @project.repositories.find_by_identifier_param(params[:repository_id])
    @path = params[:path].is_a?(Array) ? params[:path].join('/') : params[:path].to_s
    @rev = params[:rev].blank? ? @repository.default_branch : params[:rev]
    @rev_to = params[:rev_to]
  end

  def find_changeset
    if @rev.present?
      @changesets = []
      @rev.each { |val| @changesets << @repository.find_changeset_by_name(Changeset.find(val).revision.to_s.strip)}
      @changeset = @changesets.first
    end
  end
end
