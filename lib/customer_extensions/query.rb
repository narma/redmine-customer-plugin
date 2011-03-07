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

        def estimated_sum_by_group
          r = nil
          result = {}
          if grouped?
            Tracker.all.each do |t|
              begin
                  new_cond = ::Issue.merge_conditions statement, "tracker_id=#{t.id}"
                  r = ::Issue.sum 'ROUND(estimated_hours, 2)', :group => group_by_statement, :include => [:client, :status, :project], :conditions => new_cond
              rescue ActiveRecord::RecordNotFound
                  r = {nil => 0}
              end

              c = group_by_column
              if c.is_a?(QueryCustomFieldColumn)
                r = r.keys.inject({}) {|h, k| h[c.custom_field.cast_value(k)] = r[k]; h}
              end
              result[t.id] = r
            end
            result
          end

       end
     end
    end
     

    module ClassMethods
    end

  end
end

Query.send(:include, CustomerExtensions::Query)
