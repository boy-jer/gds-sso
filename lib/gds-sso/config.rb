module GDS
  module SSO
    module Config
      # Name of the User class
      mattr_accessor :user_model
      @@user_model = "User"

      # OAuth ID
      mattr_accessor :oauth_id

      # OAuth Secret
      mattr_accessor :oauth_secret

      # Location of the OAuth server
      mattr_accessor :oauth_root_url
      @@oauth_root_url = "http://localhost:3001"

      # Basic Auth Credentials (for api access when request accept
      # header is application/json)
      mattr_accessor :basic_auth_user
      mattr_accessor :basic_auth_password
      mattr_accessor :basic_auth_realm

      # No longer used, to be removed. Was generally the app name, e.g. Publisher
      mattr_accessor :default_scope
      def self.default_scope=(obj)
        if defined?(Rails)
          Rails.logger.warn "GDS::SSO::Config.default_scope is deprecated and ignored."
        end
      end
      def default_scope=(obj)
        if defined?(Rails)
          Rails.logger.warn "GDS::SSO::Config.default_scope is deprecated and ignored."
        end
      end

      @@basic_auth_realm = "API Access"

      mattr_accessor :auth_valid_for
      @@auth_valid_for = 20 * 3600

      def self.user_klass
        user_model.to_s.constantize
      end
    end
  end
end
