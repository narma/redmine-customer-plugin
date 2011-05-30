module ClientsHelper
  def project
     @project = Project.find @settings['clients_project']
  end
end


module FindFilters

  protected
  def find_issue
    @issue = Issue.find(params[:issue_id])
  rescue ActiveRecord::RecordNotFound
    render :json => false, :layout => false
  end

  def find_client_by_id
    begin
      @client = Client.find_by_id(params[:client_id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  def find_client
    @client = Client.find_by_private_key(params[:iam])
    if not @client then
      render :json => nil, :layout => false
    end
  rescue ActiveRecord::RecordNotFound
    render :json => nil, :layout => false
  end

  def find_clients
    @clients = Client.find(:all) || []
  end

end

