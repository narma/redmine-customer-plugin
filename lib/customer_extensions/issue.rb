require_dependency 'issue'


module CustomerExtensions
  module Issue

    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        belongs_to :client
        belongs_to :customer
      end
    end

    module ClassMethods
    end
  end
end

Issue.send(:include, CustomerExtensions::Issue)

