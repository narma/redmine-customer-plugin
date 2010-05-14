# Redmine customer plugin
require 'redmine'


require_dependency 'customer_extensions/project'
require_dependency 'customer_extensions/issue'
require_dependency 'customer_extensions/issues_controller_patch'
require_dependency 'customer_extensions/issues_hook'


RAILS_DEFAULT_LOGGER.info 'Starting Customer plugin for RedMine'

Redmine::Plugin.register :customer_plugin do
  name 'Customer plugin'
  author 'Eric Davis, Sergey Rublev'
  description 'This is a plugin for Redmine that can be used to track basic customer information'
  version '0.2.0'

  url 'https://projects.littlestreamsoftware.com/projects/redmine-customers' if respond_to? :url
  author_url 'http://www.littlestreamsoftware.com' if respond_to? :author_url


  project_module :customer_module do
    permission :view_client, {:clients => [:show]}
    permission :see_client_list, {:clients => [:list]}
    permission :edit_client, {:clients => [:edit, :update, :new, :create, :destroy]}
  end

  menu :project_menu, :clients, {:controller => 'clients', :action => 'show'}, :caption => :client_title
end

