module ClientsHelper
end


module FindFilters

  protected
  def find_issue
    @issue = Issue.find(params[:issue_id])
  rescue ActiveRecord::RecordNotFound
    render :json => false, :layout => false
  end

  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_client
    @client = Client.find_by_id(params[:client_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_client_by_ip
    @client = Client.find_by_ip(request.remote_ip)
    if not @client
      render :json => nil, :layout => false
    end
  rescue ActiveRecord::RecordNotFound
    render :json => nil, :layout => false
  end

  def find_clients
    @clients = Client.find(:all) || []
  end

end

