module Emigrant
  # Registry of database/language/version specific implementations of
  # the abstract adapter [Emigrant::Adapter].
  module Adapters
    class << self
      def register(language, version, klass)
        registry[[language.to_s, version.to_s]] = klass
      end

      def get(language:, version:, **)
        registry[[language.to_s, version.to_s]]
      end

      private

      def registry
        @registry ||= {}
      end
    end
  end
end
