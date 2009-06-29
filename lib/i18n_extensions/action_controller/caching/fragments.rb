require 'action_controller/caching'

module ActionController #:nodoc:
  module Caching
    module Fragments
      def fragment_cache_key(name) 
        key = super(name)
        key.is_a?(String) ? key.gsub(/:/, '.') << "_#{I18n.locale}" : key
      end
      
      def expire_fragment(name, options = nil)
        return unless perform_caching
        
        cache_store = respond_to?(:cache_store) ? cache_store : fragment_cache_store
        key = name.is_a?(Regexp) ? name : super(name)
        
        if key.is_a?(Regexp)
          self.class.benchmark("Expired fragments matching: #{key.source}") do
            cache_store.delete_matched(key, options)
          end
        else
          key = key.gsub(/:/, '.')
          self.class.benchmark("Expired fragment: #{key}, locales = #{I18n.supported_locales}") do
            I18n.supported_locales.each do |locale|
              cache_store.delete("#{key}_#{locale}", options)
            end
          end
        end
      end
    end
  end
end