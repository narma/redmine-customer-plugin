require_dependency 'project'


module CustomerExtensions
  module Project

    def self.included(base)
      base.extend ClassMethods

    end

    module ClassMethods
    end
  end
end

Project.send(:include, CustomerExtensions::Project)

