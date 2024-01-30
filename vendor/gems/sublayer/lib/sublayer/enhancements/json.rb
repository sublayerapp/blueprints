module JSON
  class << self
    alias_method :original_parse, :parse

    def parse(json, options = {})
      original_parse(json, options).with_indifferent_access
    end
  end
end
