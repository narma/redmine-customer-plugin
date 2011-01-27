require_dependency 'query'


module CustomerExtensions
  module Query

    def self.included(base)
      base.extend ClassMethods
      
      base.class_eval do
        def available_filters_with_client
          available_filters_without_client

          client_values = Client.find(:all, :order => 'name').collect { |s| [s.name, s.id.to_s] }
          @available_filters["client_id"] = { :type => :list, :order => 20, :values => client_values } unless client_values.empty?

          @available_filters
        end

        alias_method_chain :available_filters, :client

      end
   end

    module ClassMethods
    end

  end
end

Query.send(:include, CustomerExtensions::Query)


