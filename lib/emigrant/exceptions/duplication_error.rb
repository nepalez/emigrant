class Emigrant
  class DuplicationError < ArgumentError
    private

    def initialize(number, new_key, old_key)
      super "Migration ##{number} '#{new_key}' is in conflict " \
            "with the number of existing migration '#{old_key}'"
    end
  end
end
