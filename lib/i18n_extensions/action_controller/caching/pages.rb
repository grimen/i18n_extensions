require 'action_controller/caching'

module ActionController #:nodoc:
  module Caching
    module Pages
      def cache_page(content, path)
        super(content, File.join(I18n.locale.to_s, path))
      end
      
      def expire_page(path)
        I18n.available_locales.each do |locale|
          super(File.join(locale.to_s, path))
        end
      end
    end
  end
end