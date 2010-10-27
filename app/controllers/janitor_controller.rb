class JanitorController < ApplicationController
  unloadable
  
  layout 'admin'
  before_filter :require_admin

  verify :method => :post, :only => :clean, :redirect_to => { :action => :index }
  
  def index
  end

  def clean
    begin
      if params[:delete_wiki_history]
        content_table = WikiContent.table_name
        version_table = WikiContent.versioned_table_name
        version_column = WikiContent.version_column
        version_fk = WikiContent.versioned_foreign_key
        
        sql = "DELETE FROM #{version_table} WHERE id IN (SELECT v.id FROM #{content_table} c INNER JOIN #{version_table} v ON c.id = v.#{version_fk} WHERE v.version < c.#{version_column})"
        WikiContent.versioned_class.connection.execute sql
      end

      flash[:notice] = l(:notice_cleanup_succeeded)
    rescue Exception => e
      flash[:error] = l(:notice_cleanup_failed, e.message)
    end

    redirect_to :controller => 'janitor', :action => 'index'
  end
end
