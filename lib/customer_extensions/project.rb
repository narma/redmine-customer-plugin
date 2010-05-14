require_dependency 'project'


module CustomerExtensions
  module Project

    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        has_many :clients
      end
    end

    module ClassMethods
    end
  end
end

Project.send(:include, CustomerExtensions::Project)

