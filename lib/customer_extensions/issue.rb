module CustomerExtensions
  module Issue

    def self.included(base)
      base.extend ClassMethods

      base.instance_eval do
        belongs_to :client
      end
    end

    module ClassMethods
    end
  end
end

