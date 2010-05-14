require_dependency 'issue'


module CustomerExtensions
  module Issue

    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        belongs_to :clients, :class_name => 'Client', :foreign_key => 'client_id'
        belongs_to :customers, :class_name => 'Customer', :foreign_key => 'customer_id'
      end
    end

    module ClassMethods
    end
  end
end

Issue.send(:include, CustomerExtensions::Issue)

