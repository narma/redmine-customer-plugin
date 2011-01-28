class TimeManagementController < ApplicationController
  unloadable

  helper :clients
  include FindFilters

  layout 'base'
  before_filter :authorize, :except => [:rpc_get_spent_hours]
  before_filter :check_if_login_required, :except => [:rpc_get_spent_hours]


  before_filter :find_client_by_ip, :only => [:rpc_get_spent_hours]
  before_filter :find_issue, :only => :rpc_upd

  skip_before_filter :verify_authenticity_token, :only => [:rpc_new, :rpc_upd]

  verify :method => :post, :only => [:rpc_new, :rpc_upd], :render => {:nothing => true, :status => :method_not_allowed }


  def rpc_get_spent_hours
    status_closed = IssueStatus.find :first, :conditions => { :is_closed => true }
    conditions = { :client_id => @client, :status_id => status_closed }
    {:start => '>', :end => '<'}.each { |key,seq|
      begin
        if params.include? key
          conditions = Issue.merge_conditions(conditions, ["created_on #{seq} ?", params[key]])
        end
      rescue
      end
    }

    hours = Issue.sum(:estimated_hours, :conditions => conditions).round 3
    render :text => hours,
      :layout => false
  end

end

