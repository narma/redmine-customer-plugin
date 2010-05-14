class ClientsController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize
  before_filter :find_client, :only => [:edit, :update, :destroy]
  before_filter :find_clients, :only => [:list, :select]

  def show
    @clients = @project.clients
  end

  def list
    #@customers = Customer.find(:all)
  end

  def select
    #@customers = Customer.find(:all)
  end

  def edit
    #@customer = Customer.find_by_id(params[:customer_id])
  end

  def update
    #@customer = Customer.find_by_id(params[:customer_id])
    if @client.update_attributes(params[:client])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => "list", :id => params[:id]
    else
      render :action => "edit", :id => params[:id]
    end
  end

  def destroy
    #@customer = Customer.find_by_id(params[:customer_id])
    if @client.destroy
      flash[:notice] = l(:notice_successful_delete)
    else
      flash[:error] = l(:notice_unsuccessful_save)
    end
    redirect_to :action => "list", :id => params[:id]
  end

  def new
    @client = Client.new
  end

  def create
    @client = @project.clients.build(params[:client])
    if @client.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => "select", :id => params[:id]
    else
      render :action => "new", :id => params[:id]
    end
  end

  private

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

  def find_clients
    @clients = Client.find(:all) || []
  end

end

