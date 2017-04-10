module Emigrant
  # Adapter-specific collection of migrations
  #
  # It knows how to register migrations, apply, and rollback them.
  #
  class Migrator
    # Registers new migration with unique number
    #
    # @param [#to_i] number The unique positive number of the migration
    # @param [#to_s] key    The human-readable name of the migration
    # @raise [Emigrant::DuplicationError] if number has been already used
    # @return [self]
    #
    def migration(number, key)
      check_number!(number, key)
      @migrations << Migration.new(@adapter, number, key) { yield }
      self
    end

    # Migrates database upto given target migration
    #
    # @param [#to_i] target Number of topmost migration to be executed
    #
    def migrate(target = nil)
      current = @adapter.get_current
      filter(min: current, max: target).sort(:asc).each do |m|
        m.up
        current = m.number
      end
    ensure
      @adapter.set_current(current)
    end

    # Rolls back migration down to given target
    #
    # @param [#to_i] target Number of topmost migration to be left unrolled
    #
    def rollback(target = nil)
      done = @adapter.get_current + 1
      filter(min: target, max: current).sort(:desc).each do |m|
        m.down
        done = m.number
      end
    ensure
      @adapter.set_current filter(max: done).sort(:desc).first.number
    end

    private

    include Enumerable

    def initialize(settings)
      @adapter    = Registry[settings].new(settings)
      @migrations = Set.new
    end

    def each
      @migrations.each { |m| yield(m) }
    end

    def filter(min: nil, max: nil)
      reject { |m| (min&.to_i&.>= m.number) && (max&.to_i&.< m.number) }
    end

    def sort(order)
      sign = order == :desc ? -1 : 1
      sort_by { |m| m.number * sign }
    end

    def check_number!(number, key)
      existing = migrations.find { |m| m.number == number.to_i }
      raise DuplicationError.new(number, key, existing.key) if existing
    end
  end
end
