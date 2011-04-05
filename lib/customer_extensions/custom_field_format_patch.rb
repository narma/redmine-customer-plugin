require 'redmine'

module CustomerExtensions
  module CustomFieldFormat
    module ClassMethods
      def format_as_wiki(value)
        textilizable(value)
      end
    end

    def self.included(base)
      base.class_eval do
        include ApplicationHelper
      end
      base.send(:include, ClassMethods)
      base.extend(ClassMethods)

    end
  end
end

