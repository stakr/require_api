module Stakr #:nodoc:
  module RequireApi #:nodoc:
    
    # Handling to declare and request whether an API must be included
    # to render the view of this controller properly.
    module Controller
      
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
        base.helper_method :api?
      end
      
      def apis #:nodoc:
        @apis ||= {}
      end
      
      # Requests whether an API has been declared to include.
      # This methods is also available as helper method.
      # 
      # === Examples
      #   
      #   class FooController < ActionController::Base
      #     require_api :google, :maps
      #     def index
      #       api?(:google)                  # => true
      #       api?(:google, :maps)           # => true
      #       api?(:google, :visualization)  # => false
      #       api?(:yui)                     # => false
      #     end
      #   end
      def api?(*names)
        current = apis
        return false if not current.is_a?(Hash)
        names.each do |n|
          return false if not current[n].is_a?(Hash)
          current = current[n]
        end
        return true
      end
      
      # See Stakr::Controllers::RequireApi.
      module ClassMethods
        
        # Declares which API must be included.
        # 
        # === Signature
        #   
        #   require_api(name1 [, name2, ...], options = {})
        # 
        # The <tt>options</tt> Hash takes <tt>:only</tt> and <tt>:expect</tt> as keys (see <tt>before_filter</tt>).
        # 
        # === Examples
        #   
        #   class FooController < ActionController::Base
        #     require_api(:google, :maps)
        #     require_api(:yui, :slider)
        #   end
        # 
        def require_api(*args)
          options = args.extract_options!
          before_filter options do |c|
            current = c.apis
            args.each do |arg|
              value = current[arg] || {}
              current[arg] = value
              current = value
            end
          end
        end
        
      end
      
    end
    
  end
end
