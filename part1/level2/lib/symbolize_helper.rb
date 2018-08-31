# frozen_string_literal: true

# Add deep_symbolize_keys which is used in ActiveSupport
# It reduces memory usage using Symbol instead to String
module SymbolizeHelper
  extend self

  def symbolize_recursive(hash)
    {}.tap do |h|
      hash.each { |key, value| h[key.to_sym] = transform(value) }
    end
  end

  private

  def transform(thing)
    case thing
    when Hash then symbolize_recursive(thing)
    when Array then thing.map { |v| transform(v) }
    else; thing
    end
  end

  refine Hash do
    def deep_symbolize_keys
      SymbolizeHelper.symbolize_recursive(self)
    end
  end
end
