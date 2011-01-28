class ClientsController < ApplicationController
  unloadable

  helper :clients
  include FindFilters

  layout 'base'

  before_filter :authorize, :except => [:rpc_get, :rpc_new, :rpc_upd]
  before_filter :check_if_login_required, :except => [:rpc_get, :rpc_new, :rpc_upd]
  before_filter :find_client, :only => [:edit, :update, :destroy]
  before_filter :find_clients, :only => [:list, :select]

  before_filter :find_client_by_ip, :only => [:rpc_get, :rpc_new, :rpc_upd]
  before_filter :find_issue, :only => :rpc_upd

  skip_before_filter :verify_authenticity_token, :only => [:rpc_new, :rpc_upd]

  verify :method => :post, :only => [:rpc_new, :rpc_upd], :render => {:nothing => true, :status => :method_not_allowed }

  def show
    @clients = Client.find :all
  end

  def clients_project
    Project.find Setting["plugin_customer_plugin"]["clients_project"]
  end

  def rpc_get
      condition = {:client_id => @client}
      if params[:issue_id]
        condition[:id] = params[:issue_id]
      end

      render :json => [
      Tracker.all.collect { |t| {t.id => t.name } },
      clients_project.issues.all(:conditions => condition).collect { |s|
      {
        "id" => s.id,
        "created_on" => s.created_on,
        "start_date" => s.start_date,
        "subject" => s.subject,
        "description" => s.description,
        "tracker" => s.tracker.name,
        "status" => s.status.id,
        "done_ratio" => s.done_ratio,
        "spent_hours" => s.estimated_hours,
        "comments" => s.journals.all(:conditions => "notes <> '' AND client_visible = 1").collect {
          |c| {
                "comment" => c.notes,
                "author" => c.user.name,
                "created_on" => c.created_on
              }
         },
        "status_txt" => s.status.name,
        "contact" => s.custom_field_values.select { |c| c.custom_field.name=="Контакт клиента" } .collect { |v| v.value },
        "text" => s.custom_field_values.select { |c| c.custom_field.name=="Описание от клиента" } .collect { |v| v.value },
      }}],
      :layout => false
  end

  def rpc_new
     issue = clients_project.issues.build(
       :client_id => @client.id,
       :subject => params[:subject],
       :description => params[:description],
       :created_on => DateTime.now,
       :author => User.find_by_login('rpc'),
       :tracker => Tracker.find(params[:tracker])
     )

     contact_field = IssueCustomField.find_by_name('Контакт клиента')
     text_field = IssueCustomField.find_by_name('Описание от клиента')

     issue.custom_field_values = {
        contact_field.id => params[:contact],
        text_field.id => params[:text]
     }
     ok = issue.save
     render :text => ok, :layout => false
  end

  def rpc_upd
      case params[:issue_action].downcase
      when 'close', 'cancel'
        @issue.status = IssueStatus.find(:first, :conditions => { :is_closed => true } )
      when 'reopen'
        @issue.status = IssueStatus.find(:first, :conditions => { :is_default => true } )
      when 'comment'
        j = @issue.journals.new :user => User.find_by_login('rpc'), :notes => "#{params[:author]}\n#{params[:notes]}", :client_visible => true
        j.save
      end
      @issue.save
      render :text => 'ok', :layout => false
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
    @client = clients_project.clients.build(params[:client])
    if @client.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => "show", :id => params[:id]
    else
      render :action => "new", :id => params[:id]
    end
  end

end

