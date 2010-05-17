require_dependency 'query'


module CustomerExtensions
  module Query

    def self.included(base)
      base.extend ClassMethods

    end

    module ClassMethods
    end
  end
end

Query.send(:include, CustomerExtensions::Query)

