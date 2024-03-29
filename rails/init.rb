# Redmine customer plugin
require 'redmine'

require_dependency 'issue'
require_dependency 'query'
require_dependency 'project'


require_dependency 'customer_extensions/project'
require_dependency 'customer_extensions/issue'
require_dependency 'customer_extensions/query'
require_dependency 'customer_extensions/issues_controller_patch'
require_dependency 'customer_extensions/issues_hook'
require_dependency 'customer_extensions/journals_hook'
require_dependency 'customer_extensions/custom_field_format_patch'

#require_dependency 'customer_extensions/query'


RAILS_DEFAULT_LOGGER.info 'Starting Customer plugin for RedMine'

Redmine::Plugin.register :customer_plugin do
  name 'Customer plugin'
  author 'Eric Davis, Sergey Rublev'
  description 'This is a plugin for Redmine that can be used to track basic customer information'
  version '0.2.0'

  url 'https://projects.littlestreamsoftware.com/projects/redmine-customers' if respond_to? :url
  author_url 'http://www.littlestreamsoftware.com' if respond_to? :author_url

  settings :default => {
    'clients_project' => Project.first,
  }, :partial => 'settings/customer_plugin_settings'


  Query.add_available_column QueryColumn.new(:client, :sortable => "#{Client.table_name}.name", :groupable => true)

  Redmine::CustomFieldFormat.map do |fields|
    fields.register Redmine::CustomFieldFormat.new('wiki', :label => :label_wiki, :order => 8)
  end

  project_module :customer_module do
    permission :view_client, {:clients => [:show]}
    permission :see_client_list, {:clients => [:list]}
    permission :edit_client, {:clients => [:edit, :update, :new, :create, :destroy]}
    permission :rpc_client, {:clients => [:rpc_get, :rpc_new, :rpc_upd]}
  end

  menu :project_menu, :clients, {:controller => 'clients', :action => 'show'}, :caption => :client_title
  menu :account_menu, :quick_issue, {:controller => 'issues', :action => 'new', :project_id => 'pyzzle', :quick => true}, :caption => :issue_new_quick, :if => Proc.new { User.current.logged? }, :last => true


  Issue.send(:include, CustomerExtensions::Issue)
  Redmine::CustomFieldFormat.send(:include, CustomerExtensions::CustomFieldFormat)
  IssuesController.send(:include, CustomerExtensions::IssuesController)
  Project.send(:include, CustomerExtensions::Project)
  Query.send(:include, CustomerExtensions::Query)
end


module RedmineClientsProjectPatch
  def self.included(target)
    target.extend ClassMethods

    target.class_eval do
      def clients_project
        @project = Project.find @settings['clients_project']
      end
    end

  end

  module ClassMethods
  end

end
ApplicationHelper.send(:include, RedmineClientsProjectPatch)
