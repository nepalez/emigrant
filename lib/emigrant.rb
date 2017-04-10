# Standalone multi-language migrator
#
# @example Configuring databases
#   Emigrant.configure do |config|
#     config.add :psql, language:  "psql",
#                       version:    "9.4",
#                       url:        "https://localhost:9091",
#                       user:       "admin",
#                       password:   "foobar",
#                       versioning: :timestamp
#
#     config.add :cassandra, language: :cql
#                            version:  "2.1"
#                            # ...
#   end
#
# @example Alternative way to configure from a file
#   Emigrant.load "config/emigrant.yml"
#
# @example A migration
#   # db/migrations/1234_create_user.rb
#   Emigrant[:psql].migration 1234, :create_user do
#     def up
#       create_table :users do |t|
#         t.string :name
#       end
#     end
#   end
#
# @example Ways to run a migrator
#   Emigrant[:psql].migrate  1234
#   Emigrant[:psql].rollback 1234
#   Emigrant.migrate
#
module Emigrant
  require_relative "emigrant/adapter"
  require_relative "emigrant/adapters"
  require_relative "emigrant/migration"
  require_relative "emigrant/migrator"

  require_relative "emigrant/exceptions/duplication_error"

  class << self
    def [](key)
      migrators[key.to_sym]
    end

    def configure(&block)
      instance_exec(self, &block)
    end

    private

    def add(key, settings)
      migrators[key.to_sym] = \
        settings.each_with_object({}) { |(k, v), obj| obj[k.to_sym] = v }
    end

    def migrators
      @migrators ||= {}
    end
  end
end
